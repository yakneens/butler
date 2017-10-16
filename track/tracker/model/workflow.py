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
    try:
        
        my_workflow = Workflow()
        my_workflow.workflow_name = workflow_name
        my_workflow.workflow_version = workflow_version
        my_workflow.config_id = config_id
    
        now = datetime.datetime.now()
        my_workflow.last_updated_date = now
        my_workflow.created_date = now
    
        session.add(my_workflow)
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()

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
    
    try:
        my_workflow = session.query(Workflow).filter(
            Workflow.workflow_id == workflow_id).first()
    
        my_workflow.config_id = config_id
    
        now = datetime.datetime.now()
        my_workflow.last_updated_date = now
    
        session.commit()
    except:
        session.rollback()
        raise
    finally:        
        session.close()
        connection.engine.dispose()

    return my_workflow

    
def get_workflow_by_id(workflow_id):
    """
    Get a workflow with ID workflow_ID
    
    Args:
        workflow_id (id): ID of workflow
    
    Returns:
        my_workflow (Workflow): The workflow with id workflow_id.
    """
    session = connection.Session()

    try:
        my_workflow = session.query(Workflow).filter(
            Workflow.workflow_id == workflow_id).first()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return my_workflow

def list_workflows():
    """
    Return all of the existing workflows
    
    Returns:
        all_workflows(List): All of the existing workflows.
    """
    session = connection.Session()

    try:
        all_workflows = session.query(Workflow).all()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return all_workflows
    