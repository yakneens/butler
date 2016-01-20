from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import sys
import os
import uuid
import json
import configuration
import datetime


DB_URL = os.environ['DB_URL']
Base = automap_base()
#engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
engine = create_engine(DB_URL)
Base.prepare(engine, reflect=True)
Configuration = Base.classes.configuration
Analysis = Base.classes.analysis
AnalysisRun = Base.classes.analysis_run

RUN_STATUS_READY = 0
RUN_STATUS_IN_PROGRESS = 1
RUN_STATUS_COMPLETED = 2
RUN_STATUS_ERROR = 3


def create_analysis(analysis_name, start_date, config_id):
    session = Session(engine)
    
    my_analysis = Analysis()
    my_analysis.analysis_name = analysis_name
    my_analysis.start_date = start_date
    my_analysis.config_id = config_id
    
    session.add(my_analysis)
    session.commit()
    session.close()
    
    return my_analysis

def set_configuration_for_analysis(analysis_id, config_id):
    session = Session(engine)
    
    my_analysis = session.query(Analysis).filter(Analysis.analysis_id == analysis_id).first()
    
    my_analysis.config_id = config_id
    
    session.commit()
    session.close()
    
def create_analysis_run(analysis_id, config_id, workflow_id):
    session = Session(engine)
    
    my_analysis_run = AnalysisRun()
    my_analysis_run.analysis_id = analysis_id
    my_analysis_run.workflow_id = workflow_id
    my_analysis_run.config_id = config_id
    my_analysis_run.created_date = datetime.datetime.now()
    
    session.add(my_analysis_run)
    session.commit()
    session.close()
    
    return my_analysis

def set_configuration_for_analysis_run(analysis_run_id, config_id):
    session = Session(engine)
    
    my_analysis_run = session.query(AnalysisRun).filter(AnalysisRun.analysis_run_id == analysis_run_id).first()
    
    my_analysis_run.config_id = config_id
    
    session.commit()
    session.close()

def set_ready(my_run):
    if my_run.run_status == RUN_STATUS_IN_PROGRESS:
        print "Cannot put a run that's In Progress into a Ready status"
        
        logger.error("Attempting to put an In Progress run into Ready state, runID: %d", my_run.analysis_run_id)
        
        raise ValueError("Attempting to put an In Progress run into Ready state, runID: %d", my_run.analysis_run_id)
    else:
        my_run.run_status = RUN_STATUS_READY
        
def set_in_progress(my_run):
    if my_run.run_status != RUN_STATUS_READY:
        
        logger.error("Wrong run status - %d, Only a Ready run can be put In Progress, runID: %d", my_run.run_status, my_run.analysis_run_id)
        raise ValueError("Wrong run status - %d, Only a Ready run can be put In Progress, runID: %d", my_run.run_status, my_run.analysis_run_id)
    else:
        my_run.run_status = RUN_STATUS_IN_PROGRESS
        my_run.run_start_date = datetime.datetime.now()
        
def set_completed(my_run):
    if my_run.run_status != RUN_STATUS_IN_PROGRESS:
        
        logger.error("Wrong run status - %d, Only an In Progress run can be Finished, runID: %d", my_run.run_status, my_run.analysis_run_id)
        raise ValueError("Wrong run status - %d, Only an In Progress run can be Finished, runID: %d", my_run.run_status, my_run.analysis_run_id)
    else:
        my_run.run_status = RUN_STATUS_COMPLETED
        my_run.run_end_date = datetime.datetime.now()
        
def set_error(my_run):
    my_run.run_status = RUN_STATUS_ERROR