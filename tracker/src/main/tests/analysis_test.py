import pytest

from tracker.model.configuration import *
from tracker.model.analysis import *
import uuid
import json
import os
import py.path
import datetime

def test_create_analysis():
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    
    analysis_name = "My analysis"
    start_date = datetime.datetime.now(
                                       )
    my_analysis = create_analysis(analysis_name, start_date, config_id)
    
    assert my_analysis != None
    assert my_analysis.config_id == config_id
    assert my_analysis.analysis_name == analysis_name
    assert my_analysis.start_date == start_date