# -*- coding: utf-8 -*-
"""
The analysis_run module contains functions related to the management of AnalysisRun objects.
"""
import os
import datetime
import logging

from tracker.util import connection
from sqlalchemy import and_

AnalysisRun = connection.Base.classes.analysis_run

RUN_STATUS_READY = 0
RUN_STATUS_SCHEDULED = 1
RUN_STATUS_IN_PROGRESS = 2
RUN_STATUS_COMPLETED = 3
RUN_STATUS_ERROR = 4

RUN_STATUS_READY_STRING = "ready"
RUN_STATUS_SCHEDULED_STRING = "scheduled"
RUN_STATUS_IN_PROGRESS_STRING = "in-progress"
RUN_STATUS_COMPLETED_STRING = "completed"
RUN_STATUS_ERROR_STRING = "error"

run_status_list = [RUN_STATUS_READY_STRING,
                   RUN_STATUS_SCHEDULED_STRING,
                   RUN_STATUS_IN_PROGRESS_STRING,
                   RUN_STATUS_COMPLETED_STRING,
                   RUN_STATUS_ERROR_STRING]
run_status_dict = {RUN_STATUS_READY_STRING: RUN_STATUS_READY,
                   RUN_STATUS_SCHEDULED_STRING: RUN_STATUS_SCHEDULED,
                   RUN_STATUS_IN_PROGRESS_STRING: RUN_STATUS_IN_PROGRESS,
                   RUN_STATUS_COMPLETED_STRING: RUN_STATUS_COMPLETED,
                   RUN_STATUS_ERROR_STRING: RUN_STATUS_ERROR}

logger = logging.getLogger()


def get_run_status_from_string(run_status_string):
    """
    Translate string-based run statuses into int-based ones.

    Args:
        run_status_string (str): String representation of run status
     

    Returns:
        run_status (int): The int run status that corresponds to run_status_string.
    """
    run_status = run_status_dict.get(run_status_string)
    if run_status != None:
        return run_status
    else:
        raise ValueError(
            "Invalid run status string - {}".format(run_status_string))


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
    try :
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
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()
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
    
    try:
        my_analysis_run = session.query(AnalysisRun).filter(
            AnalysisRun.analysis_run_id == analysis_run_id).first()
    
        my_analysis_run.config_id = config_id
    
        now = datetime.datetime.now()
        my_analysis_run.last_updated_date = now
    
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

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
    
    try:
        my_analysis_run = session.query(AnalysisRun).filter(
            AnalysisRun.analysis_run_id == analysis_run_id).first()
    except:
        session.rollback()
    finally:
        session.close()
        connection.engine.dispose()
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
        msg = "Attempting to put an In Progress run into Ready state, runID: {}".\
            format(my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:

        session = connection.Session()
        try:
            my_run.run_status = RUN_STATUS_READY
            now = datetime.datetime.now()
            my_run.last_updated_date = now
    
            session.add(my_run)
            session.commit()
        except:
            session.rollback()
            raise
        finally:
            session.close()
            connection.engine.dispose()


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
        msg = "Wrong run status - {}, Only a Ready run can be Scheduled, runID: {}".\
            format(my_run.run_status, my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:

        session = connection.Session()
        try:
            my_run.run_status = RUN_STATUS_SCHEDULED
            now = datetime.datetime.now()
            my_run.last_updated_date = now
    
            session.add(my_run)
            session.commit()
        except:
            session.rollback()
            raise
        finally:
            session.close()
            connection.engine.dispose()


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
        msg = "Wrong run status - {}, Only a Scheduled run can be put In Progress, runID: {}".\
            format(my_run.run_status, my_run.analysis_run_id)
        print msg

        raise ValueError(msg)
    else:
        session = connection.Session()
        try:
            my_run.run_status = RUN_STATUS_IN_PROGRESS
            now = datetime.datetime.now()
            my_run.last_updated_date = now
            my_run.run_start_date = now
    
            session.add(my_run)
            session.commit()
        except:
            session.rollback()
            raise
        finally:
            session.close()
            connection.engine.dispose()


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
        err_msg = "Wrong run status - {}, Only an In Progress run can be Finished, runID: {}"
        raise ValueError(err_msg.
                         format(my_run.run_status, my_run.analysis_run_id))
    else:

        session = connection.Session()
        try:
            my_run.run_status = RUN_STATUS_COMPLETED
    
            now = datetime.datetime.now()
            my_run.last_updated_date = now
            my_run.run_end_date = now
    
            session.add(my_run)
            session.commit()
        except:
            session.rollback()
            raise
        finally:
            session.close()
            connection.engine.dispose()


def set_error(my_run):
    """
    Set the status of a given analysis run to RUN_STATUS_ERROR.

    Args:
        my_run (AnalysisRun): AnalysisRun object to update
    """
    session = connection.Session()
    try:
        
        my_run.run_status = RUN_STATUS_ERROR
    
        now = datetime.datetime.now()
        my_run.last_updated_date = now
    
        session.add(my_run)
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()


def get_number_of_runs_with_status(analysis_id, run_status):
    session = connection.Session()
    try:
        num_runs = session.query(AnalysisRun).filter(and_(
        AnalysisRun.analysis_id == analysis_id, AnalysisRun.run_status == run_status)).count()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return num_runs

def __eq__(self, other):
    return self.analysis_id == other.analysis_id and\
        self.workflow_id == other.workflow_id and\
        self.config_id == other.config_id and\
        self.run_status == other.run_status and\
        self.last_updated_date == other.last_updated_date and\
        self.created_date == other.created_date and\
        self.analysis_run_id == other.analysis_run_id

AnalysisRun.__eq__ = __eq__