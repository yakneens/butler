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


def run_test(**kwargs):
    config = get_config(kwargs)
    
    return config["test_message"]

   
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

dag = DAG("test", default_args=default_args,
          schedule_interval=None, concurrency=20000, max_active_runs=20000)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)

test_task = PythonOperator(
    task_id="test",
    python_callable=run_test,
    provide_context=True,
    dag=dag)

test_task.set_upstream(start_analysis_run_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(test_task)
