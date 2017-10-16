# -*- coding: utf-8 -*-
"""
The analysis module contains functions related to the management of Analysis objects.
"""
#import os
import datetime

#from sqlalchemy.ext.automap import automap_base
#from sqlalchemy.orm import Session
#from sqlalchemy import create_engine

from tracker.util import connection

Analysis = connection.Base.classes.analysis


def create_analysis(analysis_name, start_date, config_id):
    """
    Create an Analysis and store in the database.

    Args:
        analysis_name (str): Name of the analysis
        start_date (datetime.datetime): Start date of the analysis
        config_id (uuid): Id of the corresponding Configuration

    Returns:
        my_analysis (Analysis): The newly created analysis.
    """

    session = connection.Session()
    try:
        my_analysis = Analysis()
        my_analysis.analysis_name = analysis_name
        my_analysis.start_date = start_date
        my_analysis.config_id = config_id
    
        now = datetime.datetime.now()
        my_analysis.last_updated_date = now
        my_analysis.created_date = now
    
        session.add(my_analysis)
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()
    return my_analysis


def set_configuration_for_analysis(analysis_id, config_id):
    """
    Set the configuration for analysis with ID analysis_id.

    Args:
        analysis_id (id): ID of analysis
        config_id (uuid): Id of the corresponding Configuration

    Returns:
        my_analysis (Analysis): The updated analysis.
    """
    session = connection.Session()
    try:
        my_analysis = session.query(Analysis).filter(
            Analysis.analysis_id == analysis_id).first()
    
        my_analysis.config_id = config_id
    
        now = datetime.datetime.now()
        my_analysis.last_updated_date = now
    
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return my_analysis

def list_analyses():
    """
    Return all of the existing analyses.
    
    Returns:
        all_analyses(List): All of the existing analyses.
    """
    session = connection.Session()
    try:
        all_analyses = session.query(Analysis).all()
    except:
        session.rollback()
        raise
    finally:
        session.close()
        connection.engine.dispose()

    return all_analyses