from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import sys
import os
import uuid
import json

Base = automap_base()
engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
Base.prepare(engine, reflect=True)
Configuration = Base.classes.configuration
Workflow = Base.classes.workflow
Analysis = Base.classes.analysis
AnalysisRun = Base.classes.analysis_run

def create_configuration(config_id, config):
    if is_uuid(config_id):
        if is_json(config):
            session = Session(engine)
            
            my_config = Configuration()
            my_config.config_id = config_id
            my_config.config = config
            
            session.add(my_config)
            session.commit()
            session.close()
        else:
            raise ValueError("Configuration object not in json format.")
    else:
        raise ValueError("Configuration ID not a uuid")
    
    return my_config
    
def create_configuration_from_file(config_file_path, id_from_filename = True):
    if os.path.isfile(config_file_path):
        
        if id_from_filename:
            filename = os.path.basename(config_file_path)
            config_id = filename.split(".")[0]
        else:
            config_id = str(uuid.uuid4())
            
        f = open(config_file_path, 'r')
        config = f.read()
        
        return create_configuration(config_id, config)
         
def set_default_configuration_for_workflow(workflow_id, config_id):
    session = Session(engine)
    
    my_mapping = session.query(Workflow.workflow_id).filter(Workflow.workflow_id == workflow_id).first()
    
    if my_mapping != None:
        my_mapping.config_id = config_id
        session.commit()
        session.close()
    else:
        raise ValueError("No Workflow exists for workflow ID: " + str(workflow_id))
        
def get_effective_configuration(analysis_run_id):
    session = Session(engine)
    
    my_configs = session.query(AnalysisRun.run_id, Configuration config, Configuration.config, Configuration.config).\
        join(Analysis, AnalysisRun.analysis_id == Analysis.analysis_id).\
        join(Workflow, AnalysisRun.workflow_id == Workflow.workflow_id).\
        outerjoin(Configuration, AnalysisRun.config_id == Configuration.config_id).\
        outerjoin(Configuration, Analysis.config_id == Configuration.config_id).\
        outerjoin(Configuration, Workflow.config_id == Configuration.config_id).\ 
        first()
        
    return merge_configurations(run_config, analysis_config, workflow_config)

def merge_configurations(run_config, analysis_config, workflow_config):
    return run_config   

def is_json(my_object):
    try:
        json_object = json.loads(my_object)
    except ValueError:
        return False
    
    return True

def is_uuid(my_object):
    try:
        my_uuid = UUID(my_object, version=4)
    except ValueError:
        return False
    
    return my_uuid.hex == my_object 
    