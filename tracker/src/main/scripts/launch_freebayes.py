import sys
import os
import uuid
from time import sleep
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import json

if len(sys.argv) != 3:
    print "Wrong number of args"
    exit(1)
    
num_runs = int(sys.argv[1])
tissue_type = sys.argv[2]

Base = automap_base()
engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
Base.prepare(engine, reflect=True)

PCAWGSample = Base.classes.pcawg_samples
SampleLocation = Base.classes.sample_locations
GenotypingRun = Base.classes.genotyping_runs

session = Session(engine)


logger.debug("Getting next available samples")
available_samples = None
if tissue_type == "normal":
    available_samples = session.query(PCAWGSample.index, PCAWGSample.normal_wgs_alignment_gnos_id, SampleLocation.normal_sample_location, GenotypingRun.run_id).\
    join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
    outerjoin(GenotypingRun,PCAWGSample.index == GenotypingRun.donor_index).\
    filter(\
           and_(SampleLocation.normal_sample_location != None, \
                or_(GenotypingRun.run_status == None, and_(GenotypingRun.run_status != 1, GenotypingRun.run_status != 2))\
    )).\
    limit(num_runs)
else:
    available_samples = session.query(PCAWGSample.index, PCAWGSample.tumor_wgs_alignment_gnos_id, SampleLocation.tumor_sample_location, GenotypingRun.run_id).\
    join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
    outerjoin(GenotypingRun,PCAWGSample.index == GenotypingRun.donor_index).\
    filter(\
           and_(SampleLocation.tumor_sample_location != None, \
                or_(GenotypingRun.run_status == None, and_(GenotypingRun.run_status != 1, GenotypingRun.run_status != 2))\
    )).\
    limit(num_runs)
    
num_available_samples = len(available_samples)

if num_available_samples < num_runs:
    print "Only found " + str(num_available_samples) + " available samples to run. Will create "  + str(num_available_samples) + " configs."
    num_runs = num_available_samples

WorkflowConfig = Base.classes.workflow_config


for this_run in range(num_runs):
    
    run_uuid = str(uuid.uuid4())
    
    this_run_config = WorkflowConfig()
    this_run_config.config_id = run_uuid
    
    this_config_data = {"donor_id" : available_samples[this_run].index,\
                        "sample_id" : available_samples[this_run].sample_id, \
                        "sample_location" : available_samples[this_run].sample_location\
                        }
    this_run_config.config = this_config_data
    
    session.add(this_run_config)
    
    launch_command = "airflow trigger_dag -r " + run_uuid + " " + workflow_name
    print("Launching workflow with command: " + launch_command)
    os.system(launch_command)
    print("Workflow " + run_uuid + " launched.")
    sleep(10)
    