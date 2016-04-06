from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging
from subprocess import call

import tracker.model
from tracker.model.analysis_run import *
from tracker.util.workflow_common import *


def run_freebayes(**kwargs):

    config = get_config(kwargs)
    logger.debug("Config - {}".format(config))
    
    sample = get_sample(kwargs)

    contig_name = kwargs["contig_name"]
    contig_whitelist = config.get("contig_whitelist")
    
    
    if not contig_whitelist or contig_name in contig_whitelist:

        sample_id = sample["sample_id"]
        sample_location = sample["sample_location"]

        result_path_prefix = config["results_local_path"] + "/" + sample_id

        if (not os.path.isdir(result_path_prefix)):
            logger.info(
                "Results directory {} not present, creating.".format(result_path_prefix))
            os.makedirs(result_path_prefix)

        result_filename = "{}/{}_{}.vcf".format(
            result_path_prefix, sample_id, contig_name)

        freebayes_path = config["freebayes"]["path"]
        freebayes_mode = config["freebayes"]["mode"]
        freebayes_flags = config["freebayes"]["flags"]
        
        reference_location = config["reference_location"]
        
        if freebayes_flags == None:
            freebayes_flags = ""
        
        if freebayes_mode == "discovery":
            freebayes_command = "{} -r {} -f {} {} {} > {}".\
                format(freebayes_path,
                       contig_name,
                       reference_location,
                       freebayes_flags,
                       sample_location,
                       result_filename)
        elif freebayes_mode == "regenotyping":
            variants_location = config["variants_location"]

            freebayes_command = "{} -r {} -f {} -@ {} {} {} > {}".\
                format(freebayes_path,
                       contig_name,
                       reference_location,
                       variants_location[contig_name],
                       freebayes_flags,
                       sample_location,
                       result_filename)
        else:
             raise ValueError("Unknown or missing freebayes_mode - {}".format(freebayes_mode))   

        call_command(freebayes_command, "freebayes")

        compressed_sample_filename = compress_sample(result_filename, config)
        generate_tabix(compressed_sample_filename, config)
        copy_result(compressed_sample_filename, sample_id, config)
    else:
        logger.info(
            "Contig {} is not in the contig whitelist, skipping.".format(contig_name))


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

dag = DAG("freebayes", default_args=default_args,
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

complete_analysis_run_task = PythonOperator(
    task_id="complete_analysis_run",
    python_callable=complete_analysis_run,
    provide_context=True,
    dag=dag)

for contig_name in tracker.util.workflow_common.CONTIG_NAMES:
    freebayes_task = PythonOperator(
        task_id="freebayes_" + contig_name,
        python_callable=run_freebayes,
        op_kwargs={"contig_name": contig_name},
        provide_context=True,
        dag=dag)

    freebayes_task.set_upstream(validate_sample_task)

    complete_analysis_run_task.set_upstream(freebayes_task)
