from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging
from subprocess import call

import tracker.model
from tracker.model.analysis_run import *
from tracker.util.workflow_common import *
from tracker.util.workflow_common import uncompress_gzip_sample, compress_sample


def run_delly(**kwargs):

    config = get_config(kwargs)
    sample = get_sample(kwargs)

    sample_id = sample["sample_id"]
    sample_location = sample["sample_location"]

    result_path_prefix = config["results_local_path"] + "/" + sample_id

    if (not os.path.isdir(result_path_prefix)):
        logger.info(
            "Results directory {} not present, creating.".format(result_path_prefix))
        os.makedirs(result_path_prefix)

    delly_path = config["delly"]["path"]
    reference_location = config["reference_location"]
    variants_location = config["variants_location"]
    variants_type = config["variants_type"]
    exclude_template_path = config["delly"]["exclude_template_path"]

    result_filename = "{}/{}_{}.bcf".format(
        result_path_prefix, sample_id, variants_type)
    
    log_filename = "{}/{}_{}.log".format(
        result_path_prefix, sample_id, variants_type)

    delly_command = "{} call -t {} -g {} -v {} -o {} -x {} {} > {}".\
        format(delly_path,
               variants_type,
               reference_location,
               variants_location,
               result_filename,
               exclude_template_path,
               sample_location,
               log_filename)

    call_command(delly_command, "delly")

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

dag = DAG("delly", default_args=default_args,
          schedule_interval=None, concurrency=10000, max_active_runs=2000)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)


validate_sample_task = PythonOperator(
    task_id="validate_sample",
    python_callable=validate_sample,
    provide_context=True,
    dag=dag)

validate_sample_task.set_upstream(start_analysis_run_task)

delly_task = PythonOperator(
    task_id="delly_genotype",
    python_callable=run_delly,
    provide_context=True,
    dag=dag)

delly_task.set_upstream(validate_sample_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(delly_task)
