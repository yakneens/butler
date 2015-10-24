from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
import os.path

base_path = "/gnosdata/data/"

Base = automap_base()
engine = create_engine('postgresql://localhost:5432/germline_genotype_tracking')
Base.prepare(engine, reflect=True)

PCAWGSamples = Base.classes.pcawg_samples
SampleLocations = Base.classes.sample_locations

session = Session(engine)

my_samples = []
for sample in session.query(PCAWGSamples):
    my_samples.append(sample)
    
    tumor_directory = sample.tumor_wgs_alignment_gnos_id
    tumor_filename = sample.tumor_wgs_alignment_bam_file_name
    tumor_full_path = base_path + tumor_directory + "/" + tumor_filename
    
    normal_directory = sample.normal_wgs_alignment_gnos_id
    normal_filename = sample.normal_wgs_alignment_bam_file_name
    normal_full_path = base_path + normal_directory + "/" + normal_filename
    
    this_sample_location = SampleLocations()
    this_sample_location.donor_index = sample.index
    
    if isfile(normal_full_path):
        this_sample_location.normal_sample_location = normal_full_path
    
    if isfile(tumor_full_path):
        this_sample_location.tumor_sample_location = tumor_full_path
    
    session.add(this_sample_location)
    session.commit()
    print my_data.__dict__