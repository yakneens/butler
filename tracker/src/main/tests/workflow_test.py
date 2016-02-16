import pytest

from tracker.model.configuration import *
from tracker.model.workflow import *
import uuid
import json
import os
import py.path
import datetime


def test_create_workflow():
    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)

    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, config_id)

    assert my_workflow != None
    assert my_workflow.config_id == config_id
    assert my_workflow.workflow_name == workflow_name
    assert my_workflow.workflow_version == workflow_version


def test_set_config_for_workflow():
    workflow_name = "My workflow"
    workflow_version = "1.0"
    my_workflow = create_workflow(workflow_name, workflow_version, None)

    config_id = str(uuid.uuid4())
    config = '{"my_key":"my_val"}'
    my_config = create_configuration(config_id, config)

    my_workflow = set_configuration_for_workflow(
        my_workflow.workflow_id, my_config.config_id)

    assert my_workflow.config_id == config_id
