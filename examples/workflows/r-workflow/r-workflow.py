from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging
from subprocess import call

from string import join

import tracker.model
from tracker.model.analysis_run import *
from tracker.util.workflow_common import *


def run_R(**kwargs):
    config = get_config(kwargs)
    
    r_script = config["r_script"]
    r_param = config["r_param"]
    r_param_string = ""
    
    for param_key in r_param:
        r_param_string += " " + param_key + " " + str(r_param[param_key])
    
    
    
    r_command = r_script + r_param_string
    

    call_command(r_command, "R")

   
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.datetime(2020, 01, 01),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG("R", default_args=default_args,
          schedule_interval=None, concurrency=20000, max_active_runs=20000)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)

r_task = PythonOperator(
    task_id="R",
    python_callable=run_R,
    provide_context=True,
    dag=dag)

r_task.set_upstream(start_analysis_run_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(r_task)
