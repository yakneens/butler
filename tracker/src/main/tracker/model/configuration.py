from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from jsonmerge import merge
import os
import uuid
import json

DB_URL = os.environ['DB_URL']
Base = automap_base()
#engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
engine = create_engine(DB_URL)
Base.prepare(engine, reflect=True)
Configuration = Base.classes.configuration
Workflow = Base.classes.workflow
Analysis = Base.classes.analysis
AnalysisRun = Base.classes.analysis_run

def create_configuration(config_id, config):
    if is_uuid(config_id):
        if is_json(config):
            session = Session(engine)
            session.expire_on_commit = False
            
            my_config = Configuration()
            my_config.config_id = config_id
            my_config.config = config
            
            session.add(my_config)
            session.commit()
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
            
        my_file = open(config_file_path, 'r')
        
        my_config = my_file.read()
        
        return create_configuration(config_id, my_config)

        
def get_effective_configuration(analysis_run_id):
    session = Session(engine)
    session.expire_on_commit = False
            
    my_configs = session.query(AnalysisRun.run_id, Configuration.config.label("run_config"), Configuration.config.label("analysis_config"), Configuration.config.label("workflow_config")).\
        join(Analysis, AnalysisRun.analysis_id == Analysis.analysis_id).\
        join(Workflow, AnalysisRun.workflow_id == Workflow.workflow_id).\
        outerjoin(Configuration, AnalysisRun.config_id == Configuration.config_id).\
        outerjoin(Configuration, Analysis.config_id == Configuration.config_id).\
        outerjoin(Configuration, Workflow.config_id == Configuration.config_id).first()
        
    return merge_configurations([my_configs.workflow_config, my_configs.analysis_config, my_configs.run_config])

def merge_configurations(config_list):
    current_config = "{}"
    for config in config_list:
        current_config = merge(current_config, config)
        
    return current_config   

def is_json(my_object):
    try:
        json.loads(my_object)
    except ValueError:
        return False
    
    return True

def is_uuid(my_object):
    try:
        my_uuid = uuid.UUID(my_object, version=4)
    except ValueError:
        return False
    return str(my_uuid) == my_object 
    