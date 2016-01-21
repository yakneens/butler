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



def create_analysis(analysis_name, start_date, config_id):
    session = Session(engine)
    session.expire_on_commit = False
            
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
    session.expire_on_commit = False
            
    my_analysis = session.query(Analysis).filter(Analysis.analysis_id == analysis_id).first()
    
    my_analysis.config_id = config_id
    
    session.commit()
    session.close()
    
    return my_analysis
    
