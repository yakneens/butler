from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

import os
import logging
from subprocess import call, check_output, STDOUT, CalledProcessError


import tracker.model
from tracker.model.analysis_run import *

CONTIG_NAMES = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                "11", "12", "13", "14", "15", "16", "17", "18", "19",
                "20", "21", "22", "X", "Y"]


logger = logging.getLogger()


def get_config(kwargs):
    return kwargs["dag_run"].conf["config"]


def get_sample(kwargs):
    return kwargs["dag_run"].conf["config"]["sample"]


def start_analysis_run(**kwargs):

    config = get_config(kwargs)

    analysis_run_id = config["analysis_run_id"]

    analysis_run = get_analysis_run_by_id(analysis_run_id)
    set_in_progress(analysis_run)


def complete_analysis_run(**kwargs):

    config = get_config(kwargs)
    analysis_run_id = config["analysis_run_id"]

    analysis_run = get_analysis_run_by_id(analysis_run_id)

    set_completed(analysis_run)


def set_error_analysis_run(**kwargs):

    config = get_config(kwargs)
    analysis_run_id = config["analysis_run_id"]

    analysis_run = get_analysis_run_by_id(analysis_run_id)

    set_error(analysis_run)


def validate_sample(**kwargs):
    my_sample = get_sample(kwargs)

    sample_location = my_sample["sample_location"]

    logger.info("Trying to locate sample at %s", sample_location)

    if not os.path.isfile(sample_location):
        raise ValueError(
            "Invalid sample location or wrong permissions at {}".format(sample_location))


def call_command(command, command_name, cwd=None):
    logger.info(
        "About to invoke {} with command {}.".format(command_name, command)) 
    try:
        my_output = check_output(command, shell=True, cwd=cwd, stderr=STDOUT)
        logger.info(my_output)
    except CalledProcessError as e:
        logger.error("Program output is: " + e.output.decode("utf-8") )
        logger.error("{} execution failed {}.".format(command_name, e.returncode))
        raise


def compress_sample(result_filename, config):
    compressed_filename = result_filename + ".gz"

    bgzip = config["bgzip"]
    compression_command = "{} {} {}".format(
        bgzip["path"], bgzip["flags"], result_filename)

    call_command(compression_command, "compression")

    return compressed_filename


def uncompress_gzip_sample(result_filename, config):
    new_result_filename = os.path.splitext(result_filename)[0]
    uncompress_command = "gzip -d {}".format(result_filename)
    call_command(uncompress_command, "gzip")

    return new_result_filename


def generate_tabix(compressed_filename, config):

    tabix = config["tabix"]

    tabix_command = "{} {} {}".format(
        tabix["path"], tabix["flags"], compressed_filename)

    call_command(tabix_command, "tabix")


def copy_result(result_file_name, sample_id, config):

    results_location = "{}/{}".format(config["results_base_path"], sample_id)
    results_directory_command = "mkdir -p {}".format(results_location)

    call_command(results_directory_command, "mkdir")

    rsync = config["rsync"]
    rsync_command = "rsync {} {}* {}".format(
        rsync["flags"], result_file_name, results_location)

    call_command(rsync_command, "rsync")
