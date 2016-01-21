import pytest

from tracker.model.configuration import *
from tracker.model.workflow import *
from tracker.model.analysis import *
from tracker.model.analysis_run import *
import uuid
import json
import os
import py.path
import datetime

def test_create_analysis_run():
    
    analysis_name = "My analysis"
    start_date = datetime.datetime.now()
    my_analysis = create_analysis(analysis_name, start_date, None)
    
    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, None)
    
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    my_analysis_run = create_analysis_run(my_analysis.analysis_id, config_id, my_workflow.workflow_id)
    
    assert my_analysis_run != None
    assert my_analysis_run.config_id == config_id
    assert my_analysis_run.analysis_id == my_analysis.analysis_id
    assert my_analysis_run.workflow_id == my_workflow.workflow_id
    
def test_set_config_for_analysis_run():
    
    analysis_name = "My analysis"
    start_date = datetime.datetime.now()
    my_analysis = create_analysis(analysis_name, start_date, None)
    
    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, None)
    
    my_analysis_run = create_analysis_run(my_analysis.analysis_id, None, my_workflow.workflow_id)
    
    
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    
    my_analysis_run = set_configuration_for_analysis_run(my_analysis_run.analysis_run_id, my_config.config_id)
    
    assert my_analysis_run.config_id == config_id
        