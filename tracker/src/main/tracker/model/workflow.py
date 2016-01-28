# -*- coding: utf-8 -*-
"""
The workflow module contains functions related to the management of Workflow objects.
"""
import os
import datetime

from tracker.util import connection


Workflow = connection.Base.classes.workflow


def create_workflow(workflow_name, workflow_version, config_id):
    """
    Create a Workflow and store in the database.

    Args:
        workflow_name (str): Name of this workflow.
        workflow_version (str): Version of this workflow.
        config_id (str): Id of a configuration to associate with this workflow.


    Returns:
        my_workflow (Workflow): The newly created workflow.

    """
    session = connection.Session()


    my_workflow = Workflow()
    my_workflow.workflow_name = workflow_name
    my_workflow.workflow_version = workflow_version
    my_workflow.config_id = config_id

    now = datetime.datetime.now()
    my_workflow.last_updated_date = now
    my_workflow.created_date = now

    session.add(my_workflow)
    session.commit()

    return my_workflow


def set_configuration_for_workflow(workflow_id, config_id):
    """
    Set the configuration for workflow with ID workflow_id.

    Args:
        workflow_id (id): ID of workflow
        config_id (uuid): Id of the corresponding Configuration

    Returns:
        my_workflow (Workflow): The updated workflow.
    """
    session = connection.Session()

    my_workflow = session.query(Workflow).filter(
        Workflow.workflow_id == workflow_id).first()

    my_workflow.config_id = config_id

    now = datetime.datetime.now()
    my_workflow.last_updated_date = now

    session.commit()

    return my_workflow

def get_workflow_by_id(workflow_id):
    session = connection.Session()
    
    my_workflow = session.query(Workflow).filter(
        Workflow.workflow_id == workflow_id).first()
        
    return my_workflow
