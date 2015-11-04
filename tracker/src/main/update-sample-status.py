import sys
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import and_
import os.path
import datetime

def set_ready(my_run):
    if my_run.run_status == 1:
        print "Cannot put a run that's In Progress into a Ready status"
        exit(1)
    else:
        my_run.run_status = 0
        
def set_in_progress(my_run):
    if my_run.run_status != 0:
        print "Wrong run status" + str(my_run.run_status) + "Only a Ready run can be put In Progress"
        exit(1)
    else:
        my_run.run_status = 1
        
def set_finished(my_run):
    if my_run.run_status != 1:
        print "Wrong run status" + str(my_run.run_status) + "Only an In Progress run can be Finished"
        exit(1)
    else:
        my_run.run_status = 2
        
def set_error(my_run):
    my_run.run_status = 3

set_status = {"0": set_ready, "1": set_in_progress, "2": set_finished, "3": set_error}

#Connect to the database and reflect the schema into python objects
Base = automap_base()
engine = create_engine('postgresql://localhost:5432/germline_genotype_tracking')
Base.prepare(engine, reflect=True)

PCAWGSample = Base.classes.pcawg_samples
SampleLocation = Base.classes.sample_locations
GenotypingRun = Base.classes.genotyping_runs

session = Session(engine)

if len(sys.argv) != 4:
    print "Wrong number of args"
    exit(1)
    
this_donor_index = sys.argv[1]
this_sample_id = sys.argv[2]
new_status = sys.argv[3]

my_run = session.query(GenotypingRun).filter_by(and_(donor_index=this_donor_index, sample_id=this_sample_id)).first()

if not my_run:
    my_run = GenotypingRun()
    my_run.run_status = 0
    my_run.donor_index = this_donor_index
    my_run.sample_id = this_sample_id
    session.add(my_run)

set_status[new_status](my_run)
my_run.last_updated = datetime.datetime.now()
session.commit()
session.close()

