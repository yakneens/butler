# -*- coding: utf-8 -*-
"""
The analysis_run module contains functions related to the management of AnalysisRun objects.
"""
import os
import datetime
import logging

from tracker.util import connection

AnalysisRun = connection.Base.classes.analysis_run

RUN_STATUS_READY = 0
RUN_STATUS_SCHEDULED = 1
RUN_STATUS_IN_PROGRESS = 2
RUN_STATUS_COMPLETED = 3
RUN_STATUS_ERROR = 4

logger = logging.getLogger()

def create_analysis_run(analysis_id, config_id, workflow_id):
    """
    Create an AnalysisRun and store in the database.

    Args:
        analysis_id (int): Id of the corresponding analysis
        config_id (uuid): Id of the corresponding Configuration
        workflow_id (int): Id of the corresponding workflow


    Returns:
        my_analysis_run (AnalysisRun): The newly created analysis run.
    """
    session = connection.Session()
    
    my_analysis_run = AnalysisRun()
    my_analysis_run.analysis_id = analysis_id
    my_analysis_run.workflow_id = workflow_id
    my_analysis_run.config_id = config_id
    my_analysis_run.run_status = RUN_STATUS_READY

    now = datetime.datetime.now()
    my_analysis_run.last_updated_date = now
    my_analysis_run.created_date = now

    session.add(my_analysis_run)
    session.commit()

    return my_analysis_run


def set_configuration_for_analysis_run(analysis_run_id, config_id):
    """
    Set the configuration for analysis run with ID analysis_run_id.

    Args:
        analysis_run_id (id): ID of analysis run
        config_id (uuid): Id of the corresponding Configuration

    Returns:
        my_analysis_run (AnalysisRun): The updated analysis run.
    """
    session = connection.Session()
    
    my_analysis_run = session.query(AnalysisRun).filter(
        AnalysisRun.analysis_run_id == analysis_run_id).first()

    my_analysis_run.config_id = config_id

    now = datetime.datetime.now()
    my_analysis_run.last_updated_date = now

    session.commit()

    return my_analysis_run


def get_analysis_run_by_id(analysis_run_id):
    """
    Get the analysis run with ID analysis_run_id.

    Args:
        analysis_run_id (id): ID of analysis run
    
    Returns:
        my_analysis_run (AnalysisRun): The analysis run that has id analysis_run_id.
    """
    session = connection.Session()
    
    my_analysis_run = session.query(AnalysisRun).filter(
        AnalysisRun.analysis_run_id == analysis_run_id).first()

    return my_analysis_run

def set_ready(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_READY.
    Only possible if the current status is not RUN_STATUS_IN_PROGRESS.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update

    Raises:
        ValueError: If the analysis run is not in the correct state.
    """
    if my_run.run_status == RUN_STATUS_IN_PROGRESS:
        msg = "Attempting to put an In Progress run into Ready state, runID: {}".format(my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:

        session = connection.Session()

        my_run.run_status = RUN_STATUS_READY
        now = datetime.datetime.now()
        my_run.last_updated_date = now
        
        session.add(my_run)
        session.commit()

def set_scheduled(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_SCHEDULED.
    Only possible if the current status is RUN_STATUS_READY.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update

    Raises:
        ValueError: If the analysis run is not in the correct state.
    """
    if my_run.run_status != RUN_STATUS_READY:
        msg = "Wrong run status - {}, Only a Ready run can be Scheduled, runID: {}".format(my_run.run_status, my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:

        session = connection.Session()

        my_run.run_status = RUN_STATUS_SCHEDULED
        now = datetime.datetime.now()
        my_run.last_updated_date = now
        
        session.add(my_run)
        session.commit()

def set_in_progress(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_IN_PROGRESS.
    Only possible if the current status is RUN_STATUS_SCHEDULED.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update

    Raises:
        ValueError: If the analysis run is not in the correct state.
    """
    if my_run.run_status != RUN_STATUS_SCHEDULED:
        msg = "Wrong run status - {}, Only a Scheduled run can be put In Progress, runID: {}".format(my_run.run_status, my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:
        session = connection.Session()

        my_run.run_status = RUN_STATUS_IN_PROGRESS
        now = datetime.datetime.now()
        my_run.last_updated_date = now
        my_run.run_start_date = now

        session.add(my_run)
        session.commit()


def set_completed(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_COMPLETED.
    Only possible if the current status is RUN_STATUS_IN_PROGRESS.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update

    Raises:
        ValueError: If the analysis run is not in the correct state.
    """
    if my_run.run_status != RUN_STATUS_IN_PROGRESS:

        raise ValueError("Wrong run status - {}, Only an In Progress run can be Finished, runID: {}".\
                         format(my_run.run_status, my_run.analysis_run_id))
    else:

        session = connection.Session()

        my_run.run_status = RUN_STATUS_COMPLETED

        now = datetime.datetime.now()
        my_run.last_updated_date = now
        my_run.run_end_date = now

        session.add(my_run)
        session.commit()


def set_error(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_ERROR.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update
    """
    session = connection.Session()

    my_run.run_status = RUN_STATUS_ERROR

    now = datetime.datetime.now()
    my_run.last_updated_date = now

    session.add(my_run)
    session.commit()
