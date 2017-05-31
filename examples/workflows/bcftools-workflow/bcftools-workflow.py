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


def bcftools(**kwargs):

    config = get_config(kwargs)
    sample = get_sample(kwargs)

    sample_id = sample["sample_id"]
    sample_path_prefix = sample["path_prefix"]
    
    filenames_list = sample["filename_list"]
    full_path_filenames_list = map(lambda(x): sample_path_prefix + "/" + x, filenames_list)
    filenames_string = " ".join(full_path_filenames_list)
    
    
    result_path_prefix = config["results_local_path"] + "/" + sample_id
    
    bcftools_path = config["bcftools"]["path"]
    bcftools_flags = config["bcftools"]["flags"]
    bcftools_operation = config["bcftools"]["operation"]
    
    
    if (not os.path.isdir(result_path_prefix)):
        logger.info(
            "Results directory {} not present, creating.".format(result_path_prefix))
        os.makedirs(result_path_prefix)

    result_filename = "{}/{}_merged.vcf.gz".format(
        result_path_prefix, sample_id)

    bcftools_command = 'bcftools {} {} {} -o {}'.\
        format(bcftools_operation,
               bcftools_flags,
               filenames_string,
               result_filename)
    

    call_command(bcftools_command, "bcftools")

    generate_tabix(result_filename, config)
    copy_result(result_filename, sample_id, config)
   
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

dag = DAG("bcftools", default_args=default_args,
          schedule_interval=None, concurrency=20000, max_active_runs=20000)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)

bcftools_task = PythonOperator(
    task_id="bcftools",
    python_callable=bcftools,
    provide_context=True,
    dag=dag)

bcftools_task.set_upstream(start_analysis_run_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(bcftools_task)
