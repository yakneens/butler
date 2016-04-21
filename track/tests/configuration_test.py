import uuid
import json
import pytest
from tracker.model.workflow import *
from tracker.model.configuration import *
from tracker.model.analysis import *
from tracker.model.analysis_run import *
import tracker



def test_create_config():
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = tracker.model.configuration.create_configuration(
        config_id, config)

    assert my_config != None
    assert my_config.config_id == config_id
    assert my_config.config == json.loads(config)


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
    assert my_config.config == json.loads(config)
    
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
    ([{"val_1": {"sub_val_1": 1, "sub_val_2": 1}},\
      {"val_1": {"sub_val_2": 2, "sub_val_3": 2}}],\
     {"val_1": {"sub_val_1": 1, "sub_val_2": 2, "sub_val_3": 2}}),
    ([{"val_1": 1}, {"val_1": 2}, {}], {"val_1": 2}),
    ([{"val_1": 1}, {}, {"val_1": 3}], {"val_1": 3}),
    ([{"val_1": 1}, {"val_1": 2}, {"val_1": 3}], {"val_1": 3}),
    ([{"val_1": 1, "val_2": 1, "val_3": 1}, {"val_2": 2, "val_3": 2}, {"val_3": 3}],\
      {"val_1": 1, "val_2": 2, "val_3": 3}),
    ([{"val_1": [1,1,1]}, {"val_1": [2,2]}, {"val_1": [3]}], {"val_1": [3]}),
    ([{"val_1": {"sub_val_1": 1, "sub_val_2": 1}, "val_2": 1},\
      {"val_1": {"sub_val_2": 2, "sub_val_3": 2}},\
      {"val_1": {"sub_val_1": 3, "sub_val_2": 3, "sub_val_3": 3}}],\
     {"val_1": {"sub_val_1": 3, "sub_val_2": 3, "sub_val_3": 3}, "val_2": 1}),
])    
def test_merge_configurations(config_list, config_final):
    merged_result = merge_configurations(config_list)
    
    assert merged_result == config_final

@pytest.mark.parametrize("config_list, config_final", [
    ([{"val_1": 1}, {"val_1": 2}, {}], {"val_1": 2}),
    ([{"val_1": 1}, {}, {"val_1": 3}], {"val_1": 3}),
    ([{"val_1": 1}, {"val_1": 2}, {"val_1": 3}], {"val_1": 3}),
    ([{"val_1": 1, "val_2": 1, "val_3": 1}, {"val_2": 2, "val_3": 2}, {"val_3": 3}],\
      {"val_1": 1, "val_2": 2, "val_3": 3}),
    ([{"val_1": [1,1,1]}, {"val_1": [2,2]}, {"val_1": [3]}], {"val_1": [3]}),
    ([{"val_1": {"sub_val_1": 1, "sub_val_2": 1}, "val_2": 1},\
      {"val_1": {"sub_val_2": 2, "sub_val_3": 2}},\
      {"val_1": {"sub_val_1": 3, "sub_val_2": 3, "sub_val_3": 3}}],\
     {"val_1": {"sub_val_1": 3, "sub_val_2": 3, "sub_val_3": 3}, "val_2": 1}),
]) 
def test_get_effective_configuration(config_list, config_final):
    
    config_id = str(uuid.uuid4())
    create_configuration(config_id, json.dumps(config_list[0]))

    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, config_id)
    
    config_id = str(uuid.uuid4())
    create_configuration(config_id, json.dumps(config_list[1]))

    analysis_name = "My analysis"
    start_date = datetime.datetime.now()
    my_analysis = create_analysis(
        analysis_name, start_date, config_id)
    
    config_id = str(uuid.uuid4())
    create_configuration(config_id, json.dumps(config_list[2]))
    my_analysis_run = create_analysis_run(
        my_analysis.analysis_id, config_id, my_workflow.workflow_id)
    
    my_result = get_effective_configuration(my_analysis_run.analysis_run_id)
    
    assert my_result == config_final

@pytest.mark.parametrize("string_to_test", [
  pytest.mark.xfail(("")),
  ("2d162bdf-aa56-46ff-81ba-ea9de850bbeb"),
  pytest.mark.xfail(("2d162bdfaa5646ff81baea9de850bbeb")),  
  pytest.mark.xfail(('xd162bdfaa5646ff81baea9de850bbeb')),
])    
def test_is_uuid(string_to_test):
    assert is_uuid(string_to_test) == True
    
@pytest.mark.parametrize("string_to_test", [
  pytest.mark.xfail(("")),
  ("{}"),
  ('{"key": "val"}'),
  ('{"val_1": []}'),
  ('{"val_1": [1,1]}'),
  ('{"val_1": {"sub_val_1": 1}}'),
  ('{"val_1": {"sub_val_1": 1, "sub_val_2": 1}, "val_2": 1}'),
  pytest.mark.xfail(('{"key": val')),
  pytest.mark.xfail(('{"key": val}')),
  pytest.mark.xfail(('{"key" val}')),
  pytest.mark.xfail(('{"key: val}')),
  pytest.mark.xfail(('{"key: val, "key_2": val}')),
  pytest.mark.xfail(('{key: val}')),
])    
def test_is_json(string_to_test):
    assert is_json(string_to_test) == True
    
@pytest.mark.parametrize("config,new_config,final_config", [
  ({}, {"key": "val"}, {"key": "val"}),
  ({"key": "val"}, {"key": "new_val"}, {"key": "new_val"}),
  ({"key": "val"}, {"key_2": "val_2"}, {"key": "val", "key_2": "val_2"}),
  ({"key": ["val"]}, {"key": ["val_2", "val_3"]}, {"key": ["val_2", "val_3"]}),
  ({"key": {"sub_key": "val"}}, {"key": {"sub_key": "new_val"}}, {"key": {"sub_key": "new_val"}}),
  ({"key": {"sub_key": "val"}}, {"key": {"sub_key_2": "val_2", "sub_key_3": "val_3"}}, {"key": {"sub_key": "val","sub_key_2": "val_2", "sub_key_3": "val_3"}})
])    
def test_update_configuration(config, new_config, final_config):
    config_id = str(uuid.uuid4())
    config_str = json.dumps(config)
    my_config = tracker.model.configuration.create_configuration(
        config_id, config_str)
    
    updated_config = tracker.model.configuration.update_configuration(my_config.config_id, new_config)
    
    assert updated_config.config == final_config

    
    