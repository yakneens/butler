# -*- coding: utf-8 -*-
"""
The workflow module contains functions related to the management of Workflow objects.
"""
import os
import datetime

from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine

DB_URL = os.environ['DB_URL']
Base = automap_base()
engine = create_engine(DB_URL)
Base.prepare(engine, reflect=True)
Workflow = Base.classes.workflow


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
    session = Session(engine)
    session.expire_on_commit = False

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
    session = Session(engine)
    session.expire_on_commit = False

    my_workflow = session.query(Workflow).filter(
        Workflow.workflow_id == workflow_id).first()

    my_workflow.config_id = config_id

    now = datetime.datetime.now()
    my_workflow.last_updated_date = now

    session.commit()

    return my_workflow
