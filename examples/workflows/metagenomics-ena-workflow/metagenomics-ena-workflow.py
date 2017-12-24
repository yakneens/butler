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

import uuid
import os.path
import datetime
import re
import json
import distutils.util

from subprocess import check_output

def get_cwl_config_template(cwl_config_template_location):
    fp = open(cwl_config_template_location)
    cwl_config = json.load(fp)
    fp.close()
    return cwl_config

def prepare_cwl_config(cwl_config, config, sample):
    output_basename = config["output_basename"]
    ena_accession = config["ena_accession"]
    threads = config["threads"]
    kraken_db_path = config["kraken_db_path"]
    result_path_prefix = "/tmp/"
    
    if (not os.path.isdir(result_path_prefix)):
        logger.info(
            "Results directory {} not present, creating.".format(result_path_prefix))
        os.makedirs(result_path_prefix)
    
    cwl_config_location = config["cwl_config_location"]
    
    fp = open(cwl_config_location,"w")
    json.dump(cwl_config, fp)
    fp.close()
    
    return cwl_config_location
    

def run_wf(**kwargs):
    config = get_config(kwargs)
    cwl_flags = config["cwl_flags"]
    
    result_path_prefix = config["results_base_path"] + "/" + sample_id
    
    cwl_config_location = prepare_cwl_config(get_cwl_config_template(config["cwl_config_template_location"]), config, sample)
    
    
    cwl_file_location = config["cwl_file_location"]
    
    tmp_outdir = config["tmp_outdir"]
    
    cwl_command = "{} {} --outdir {} --tmp-outdir-prefix {} {} {}".\
        format("cwl-runner",
               cwl_flags,
               result_path_prefix,
               tmp_outdir,
               cwl_file_location,
               cwl_config_location)
    call_command(cwl_command, "cwl")

   
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

dag = DAG("metagenomics_ena", default_args=default_args,
          schedule_interval=None, concurrency=500, max_active_runs=500)


start_analysis_run_task = PythonOperator(
    task_id="start_analysis_run",
    python_callable=start_analysis_run,
    provide_context=True,
    dag=dag)

run_wf_task = PythonOperator(
    task_id="run_wf",
    python_callable=run_wf,
    provide_context=True,
    dag=dag)

run_wf_task.set_upstream(start_analysis_run_task)

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

complete_analysis_run_task.set_upstream(run_wf_task)
