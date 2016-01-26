#!/usr/bin/env python
from uuid import uuid4
import argparse
import os

from airflow.operators import TriggerDagRunOperator

from tracker.model.configuration import create_configuration_from_file, create_configuration, get_effective_configuration
from tracker.model.analysis_run import create_analysis_run

def set_up_dag_run(context, dag_run_obj):
    dag_run_obj.payload = { "config": context["config"] }
    dag_run_obj.run_id = str(uuid4())
    print context
    return dag_run_obj

def parse_args():
    my_parser = argparse.ArgumentParser()
    
    my_parser.add_argument("-w", "--workflow_id", help="ID of the workflow to run", dest="workflow_id", required=True)
    my_parser.add_argument("-a", "--analysis_id", help="ID of the analysis to run", dest="analysis_id", required=True)
    my_parser.add_argument("-c", "--config_location", help="Path to a directory that contains analysis run configuration files. Each file will generate one analysis run.", dest="config_location", required=True)

    my_args = my_parser.parse_args()
    
    return my_args

def process_configs(config_location, analysis_id, workflow_id):
    
    my_dag_run = TriggerDagRunOperator(
        dag_id="test-dag", 
        python_callable=set_up_dag_run,
        task_id="run_my_test",
        owner="airflow")
    
    if not os.path.isdir(config_location):
        raise ValueError("config_location must be a path to a directory")
    
    (root, dirs, files) = os.walk(config_location)
    
    for config_file in files:
        current_config = create_configuration_from_file(config_file)
        
        current_analysis_run = create_analysis_run(analysis_id, current_config.config_id, workflow_id)
        
        effective_config = get_effective_configuration(current_analysis_run.analysis_run_id)
        
        my_dag_run.execute({"config": effective_config})
        
    
args = parse_args()

process_configs(args.config_location, args.analysis_id, args.workflow_id)



