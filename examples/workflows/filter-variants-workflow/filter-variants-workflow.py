from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging
from subprocess import call

import tracker.model
from tracker.model.analysis_run import *
from tracker.util.workflow_common import *


def filter_variants(**kwargs):

    config = get_config(kwargs)
    sample = get_sample(kwargs)

    sample_id = sample["sample_id"]
    sample_path_prefix = sample["path_prefix"]
    sample_filename = sample["filename"]
    
    sample_location = "{}/{}".format(sample_path_prefix, sample_filename)

    result_path_prefix = config["results_local_path"] + "/" + sample_id
    
    vcffilter_path = config["vcffilter"]["path"]
    vcffilter_flags = config["vcffilter"]["flags"]
    
    vt_path = config["vt"]["path"]
    vt_command = config["vt"]["command"]
    vt_flags = config["vt"]["flags"]

    if (not os.path.isdir(result_path_prefix)):
        logger.info(
            "Results directory {} not present, creating.".format(result_path_prefix))
        os.makedirs(result_path_prefix)

    result_filename = "{}/{}_filtered.vcf".format(
        result_path_prefix, sample_filename)

    reference_location = config["reference_location"]
    
    
    filtering_command = 'zcat {} | {} -f "{}" | {} {} -r {} {} - -o {}'.\
        format(sample_location,
               vcffilter_path,
               vcffilter_flags,
               vt_path,
               vt_command,
               reference_location,
               vt_flags,
               result_filename)
    

    call_command(filtering_command, "vcf-filter")

    compressed_sample_filename = compress_sample(result_filename, config)
    generate_tabix(compressed_sample_filename, config)
    copy_result(compressed_sample_filename, sample_id, config)
   
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

dag = DAG("filter-vcf", default_args=default_args,
          schedule_interval=None, concurrency=20000, max_active_runs=20000)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)



filter_task = PythonOperator(
    task_id="filter_variants",
    python_callable=filter_variants,
    provide_context=True,
    dag=dag)

filter_task.set_upstream(start_analysis_run_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(filter_task)
