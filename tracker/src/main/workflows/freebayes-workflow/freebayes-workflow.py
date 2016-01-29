from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging

import tracker.model
from tracker.model.analysis_run import *



def get_config(kwargs):
    return kwargs["dag_run"].conf["config"]

def get_sample(kwargs):
    return kwargs["dag_run"].conf["config"]["sample"]


def start_analysis_run(**kwargs):
    
    config = get_config(kwargs)
    sample = get_sample(kwargs)

    analysis_run_id = config["analysis_run_id"]
    
    analysis_run = get_analysis_run_by_id(analysis_run_id)
    set_in_progress(analysis_run)

def validate_sample(**kwargs):
    my_sample = get_sample(kwargs)
    
    sample_location = my_sample["sample_location"]
    
    logger.info("Trying to locate sample at %s", sample_location)
    
    if not os.path.isfile(sample_location):
        raise ValueError("Invalid sample location or wrong permissions at {}".format(sampl_location))


def call_command(command, command_name):
    logger.info("About to invoke {} with command {}.".format(command_name, command))
    
    try:
        retcode = call(freebayes_command, shell=True)
        if retcode != 0:
            msg = "{} terminated by signal {}.".format(command_name, retcode)
            logger.error(msg)
            raise Exception(msg)
        else:
            logger.info("{} terminated normally.".format(command_name))
    except OSError as e:
        logger.error("{} execution failed {}.".format(command_name,e))
        raise

def run_freebayes(**kwargs):
    
    config = get_config(kwargs)
    sample = get_sample(kwargs)
    
    contig_name = kwargs["contig_name"]
    
    sample_id = sample["sample_id"]
    sample_location = sample["sample_location"]
    
    result_path_prefix = config["results_local_path"] + sample_id

    if (not os.path.isdir(result_path_prefix)):
        logger.info("Results directory {} not present, creating.".format(result_path_prefix))
        os.makedirs(result_path_prefix)

    result_filename =  "{}/{}_{}.vcf".format(result_path_prefix, sample_id, contig_name)
        
    freebayes_path = config["freebayes"]["path"]
    reference_location = config["reference_location"]
    variants_location = config["variants_location"]
    
    freebayes_command = "{} -r {} -f {} -@ {} -l {} > {}".\
        format(freebayes_path, \
             contig_name, \
             reference_location, \
             variants_location[contig_name], \
             sample_location, \
             result_filename)
        
    call_command(freebayes_command, "freebayes")

    compressed_sample_filename = compress_sample(result_filename, config)
    generate_tabix(compressed_sample_filename, config)
    copy_result(compressed_sample_filename, sample_id, config)



def compress_sample(result_filename, config):
    compressed_filename = result_filename + ".gz"
    
    bgzip = config["bgzip"]
    compression_command = "{} {} {}".format(bgzip["path"], bgzip["flags"], result_filename)

    call_command(compression_command, "compression")

    return compressed_filename


def generate_tabix(compressed_filename, config):
    
    tabix = config["tabix"]
    
    tabix_command = "{} {} {}".format(tabix["path"], tabix["flags"], compressed_filename)

    call_command(tabix_command, "tabix")


def copy_result(result_file_name, sample_id, config):
    
    results_location = "{}/{}".format(config["results_base_path"], sample_id)
    results_directory_command = "mkdir -p {}".format(results_location)
    
    call_command(results_directory_command, "mkdir")
    
    
    rsync = config["rsync"]
    rsync_command = "rsync {} {}* {}".format(rsync["flags"], result_file_name, results_location)
    
    call_command(rsync_command, "rsync")
    

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


for contig_name in contig_names:
    freebayes_task = PythonOperator(
        task_id="freebayes_" + contig_name,
        python_callable=run_freebayes,
        op_kwargs={"contig_name": contig_name},
        provide_context=True,
        dag=dag)

    freebayes_task.set_upstream(validate_sample_task)

    complete_analysis_run_task.set_upstream(genotyping_task)
