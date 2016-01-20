import pytest

from tracker.model.configuration import *
import uuid
import json
import os
import py.path

def test_create_config():
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)
    
    assert my_config != None
    assert my_config.config_id == config_id
    assert my_config.config == config

def test_create_config_from_file(tmpdir):
    config_file_path = str(tmpdir.join('my_config_file.json'))
    my_file = open(config_file_path, 'w')
    my_file.write('{"my_key":"my_val"}')
    
    my_other_file = open(config_file_path, 'r+')
    print os.stat(config_file_path)
    my_config = create_configuration_from_file(config_file_path,False)
    
    assert my_config != None
    assert my_config.config_id == config_id
    assert my_config.config == config
