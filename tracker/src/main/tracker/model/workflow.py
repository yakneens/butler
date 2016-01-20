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
Workflow = Base.classes.workflow

def create_workflow(workflow_name, workflow_version, config_id):
    session = Session(engine)
    session.expire_on_commit = False
            
    my_workflow = Workflow()
    my_workflow.workflow_name = workflow_name
    my_workflow.workflow_version = workflow_version
    my_workflow.config_id = config_id
    
    session.add(my_workflow)
    session.commit()
    session.close()
    
    return my_workflow

def set_configuration_for_workflow(workflow_id, config_id):
    session = Session(engine)
    session.expire_on_commit = False
            
    my_workflow = session.query(Workflow).filter(Workflow.workflow_id == workflow_id).first()
    
    my_workflow.config_id = config_id
    
    session.commit()
    session.close()
    
    return my_workflow
