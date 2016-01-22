import uuid
import json
import pytest
from tracker.model.configuration import *
import tracker



def test_create_config():
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = tracker.model.configuration.create_configuration(
        config_id, config)

    assert my_config != None
    assert my_config.config_id == config_id
    assert my_config.config == config


@pytest.mark.parametrize("id_from_filename", [('True'), ('False')])
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

    my_config = create_configuration_from_file(
        config_file_path, id_from_filename)

    assert my_config != None
    assert my_config.config == config
    
@pytest.mark.parametrize("config_list, config_final", [
    ([{}], {}), 
    ([{"val_1": 1}], {"val_1": 1}),
    ([{"val_1": 1}, {}], {"val_1": 1}),
    ([{"val_1": 1}, {"val_1": 2}], {"val_1": 2}),
    ([{"val_1": 1}, {"val_2": 2}], {"val_1": 1, "val_2": 2}),
    ([{"val_1": []}, {"val_1": [1]}], {"val_1": [1]}),
    ([{"val_1": [1]}, {"val_1": []}], {"val_1": []}),
    ([{"val_1": [1]}, {"val_1": [2]}], {"val_1": [2]}),
    ([{"val_1": [1,1]}, {"val_1": [2]}], {"val_1": [2]}),
    ([{"val_1": {}}, {"val_1": {"sub_val_1": 2}}], {"val_1": {"sub_val_1": 2}}),
    ([{"val_1": {"sub_val_1": 1}}, {"val_1": {"sub_val_1": 2}}], {"val_1": {"sub_val_1": 2}}),
    ([{"val_1": {"sub_val_1": 1}}, {"val_1": {"sub_val_2": 2}}], {"val_1": {"sub_val_1": 1, "sub_val_2": 2}}),
    ([{"val_1": {"sub_val_1": 1, "sub_val_2": 1}}, {"val_1": {"sub_val_2": 2, "sub_val_3": 2}}], {"val_1": {"sub_val_1": 1, "sub_val_2": 2, "sub_val_3": 2}}),
    
])    
def test_merge_configurations(config_list, config_final):
    #config_1 = {"baseval_1": "1", "baseval_2": "1", "baseval_3": "1", "baseval_4": [1], "baseval_5": {"sub_base_1": "1", "sub_base_2": "1"}}
    #config_2 = {"baseval_2": "2", "baseval_3": "2"}
    #config_3 = {"baseval_3": "3", "baseval_4": [3,3,3], "baseval_5": {"sub_base_1": "3"}}
    #config_final = {"baseval_1": "1", "baseval_2": "2", "baseval_3": "3", "baseval_4": [3,3,3], "baseval_5": {"sub_base_1": "3", "sub_base_2": "1"}}
    
    #config_list = [config_1, config_2, config_3]

    merged_result = merge_configurations(config_list)
    
    assert merged_result == config_final
    
    