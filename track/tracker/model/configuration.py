# -*- coding: utf-8 -*-
"""
The configuration module contains functions related to the management of Configuration objects.
"""

import os
import uuid
import json
import datetime

from jsonmerge import merge

from sqlalchemy.orm import aliased
from tracker.util import connection

Configuration = connection.Base.classes.configuration
Workflow = connection.Base.classes.workflow
Analysis = connection.Base.classes.analysis
AnalysisRun = connection.Base.classes.analysis_run


def create_configuration(config_id, config):
    """
    Create a Configuration and store in the database.

    Args:
        config_id (uuid): Id to use for this configuration.
        config (str): String representation of the JSON configuration.


    Returns:
        my_config (Configuration): The newly created configuration.

    Raises:
        ValueError: If the configuration object is not in json format.
        If the configuration ID is not a valid UUID.
    """
    if is_uuid(config_id):
        if is_json(config):
            session = connection.Session()
            
            try:

                my_config = Configuration()
                my_config.config_id = config_id
                my_config.config = json.loads(config)
    
                now = datetime.datetime.now()
                my_config.last_updated_date = now
                my_config.created_date = now
    
                session.add(my_config)
                session.commit()
            except:
                session.rollback()
                raise
            finally:
                session.close()
                connection.engine.dispose()

        else:
            raise ValueError("Configuration object not in json format.")
    else:
        raise ValueError("Configuration ID not a uuid")

    return my_config


def create_configuration_from_file(config_file_path, id_from_filename=False):
    """
    Create a Configuration from a file and store in the database.

    Args:
        config_file_path (str): Path to the JSON configuration file.
        id_from_filename (bool): 
            False if config_id for the new configuration should be
            generated internally.
            If set to True the ID will be harvested from the configuration file name.

    Returns:
        my_config (Configuration): The newly created configuration.

    Raises:
        ValueError: If the configuration object is not in json format.
                    If the configuration ID is not a valid UUID.
    """
    if os.path.isfile(config_file_path):

        if id_from_filename:
            filename = os.path.basename(config_file_path)
            config_id = filename.split(".")[0]
        else:
            config_id = str(uuid.uuid4())

        my_file = open(config_file_path, 'r')

        my_config = my_file.read()

        return create_configuration(config_id, my_config)


def get_effective_configuration(analysis_run_id):
    """
    Given an analysis run return its effective configuration.
    The effective configuration consists of a merged set of
    workflow, analysis, and analysis_run configurations

    Args:
        analysis_run_id (int): Id to use for analysis run lookup.

    Returns:
        my_config (str): The effective configuration of this analysis run.

    """
    session = connection.Session()
    try:        
        run_config = aliased(Configuration)
        analysis_config = aliased(Configuration)
        workflow_config = aliased(Configuration)
    
        my_configs = session.query(AnalysisRun.analysis_run_id, run_config.config.label("run_config"),
                                   analysis_config.config.label("analysis_config"), 
                                   workflow_config.config.label("workflow_config")).\
            join(Analysis, AnalysisRun.analysis_id == Analysis.analysis_id).\
            join(Workflow, AnalysisRun.workflow_id == Workflow.workflow_id).\
            outerjoin(run_config, AnalysisRun.config_id == run_config.config_id).\
            outerjoin(analysis_config, Analysis.config_id == analysis_config.config_id).\
            outerjoin(workflow_config, Workflow.config_id == workflow_config.config_id).\
            filter(AnalysisRun.analysis_run_id == analysis_run_id).first()
        config_list = [my_configs.workflow_config,
                       my_configs.analysis_config, my_configs.run_config]
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return merge_configurations(config_list)


def merge_configurations(config_list):
    """
    Merge a list of JSON formatted configurations into a single object.
    Objects earlier on in the list supersede later objects.


    Args:
        config_list ([Configuration]): List of configurations to merge.

    Returns:
        current_config (json): The merged configuration.

    """
    current_config = {}
    for config in config_list:
        current_config = merge(current_config, config)

    return current_config


def update_configuration(config_id, new_config):
    """
    Update the configuration with id config_id with values stored in new_config.

    Args:
        config_id (int): Id of configuration to update.
        new_config (dict): A dictionary containing updated values.
        
    Returns:
        updated_config(Configuration): the updated configuration.

    """
    session = connection.Session()
    try:
        my_config = session.query(Configuration).filter(
            Configuration.config_id == config_id).first()
        updated_config = merge_configurations([my_config.config, new_config])
        my_config.config = updated_config
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()
    
    return my_config


def is_json(my_object):
    """
    Determine whether an object passed as parameter is in JSON format.

    Args:
        my_object (str): Object to validate.

    Returns:
        is_json (bool): True when my_object can be parsed as json, False otherwise.

    """
    try:
        json.loads(my_object)
    except ValueError:
        return False

    return True


def is_uuid(my_object):
    """
    Determine whether a string passed in as a parameter is a UUID.

    Args:
        my_object (str): String representation of the UUID.

    Returns:
        is_uuid (bool): True if my_object can be parsed as a UUID, False otherwise.

    """
    try:
        my_uuid = uuid.UUID(my_object, version=4)
    except ValueError:
        return False
    return str(my_uuid) == my_object

def get_configuration_by_id(config_id):
    """
    Get the configuration with ID config_id.

    Args:
        config_id (id): ID of configuration

    Returns:
        my_configuration (Configuration): The configuration that has id config_id.
    """
    session = connection.Session()
    try:
        my_configuration = session.query(Configuration).filter(
            Configuration.config_id == config_id).first()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()
    return my_configuration
