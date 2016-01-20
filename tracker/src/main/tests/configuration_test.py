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

@pytest.mark.parametrize("id_from_filename", [('True'),('False')])
def test_create_config_from_file(tmpdir, id_from_filename):
    
    config_filename = "my_config"
    if id_from_filename:
        config_id = str(uuid.uuid4())
        config_filename = config_id
    
    config_file_path = str(tmpdir.join(config_filename + '.json'))
    config = '{"my_key":"my_val"}'
    my_file = open(config_file_path, 'w')
    my_file.write(config)
    my_file.close()
    
    my_config = create_configuration_from_file(config_file_path,id_from_filename)
    
    assert my_config != None
    assert my_config.config == config
