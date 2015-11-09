from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
import os.path
import datetime

base_path = "/gnosdata/data/"

#Connect to the database and reflect the schema into python objects
Base = automap_base()
engine = create_engine('postgresql://pcawg_admin:pcawg@run-tracking-db.service.consul:5432/germline_genotype_tracking')
Base.prepare(engine, reflect=True)

PCAWGSample = Base.classes.pcawg_samples
SampleLocation = Base.classes.sample_locations

session = Session(engine)

#Create a dict mapping donor_index to sample_location
sample_locations = {el.donor_index: el for el in session.query(SampleLocation)}

for sample in session.query(PCAWGSample):
    print "Processing Donor #: " + str(sample.index) + " Id: " + sample.submitter_donor_id
    
    #File location of the tumor BAM file
    tumor_directory = sample.tumor_wgs_alignment_gnos_id
    tumor_filename = sample.tumor_wgs_alignment_bam_file_name
    tumor_full_path = base_path + tumor_directory + "/" + tumor_filename
    
    #File location of the normal BAM file
    normal_directory = sample.normal_wgs_alignment_gnos_id
    normal_filename = sample.normal_wgs_alignment_bam_file_name
    normal_full_path = base_path + normal_directory + "/" + normal_filename
    
    #If a sample_location record for this donor already exists, work with it
    this_sample_location = sample_locations.get(sample.index)
    
    #If sample_location for this donor does not yet exist, create it.
    if not this_sample_location:    
        this_sample_location = SampleLocation()
        this_sample_location.donor_index = sample.index
    
    is_found = False
    
    #If file path to the normal BAM file exists, record it
    if os.path.isfile(normal_full_path):
        this_sample_location.normal_sample_location = normal_full_path
        is_found = True
    
    #If file path to the tumor BAM file exists, record it
    if os.path.isfile(tumor_full_path):
        this_sample_location.tumor_sample_location = tumor_full_path
        is_found = True
    
    #If at least one file path (tumor or normal) exists, persist the sample_locaion record
    if is_found:
        print "BAM files found for Donor: " + sample.submitter_donor_id
        this_sample_location.last_updated = datetime.datetime.now()
        session.add(this_sample_location)
        session.commit()
        
session.close() 