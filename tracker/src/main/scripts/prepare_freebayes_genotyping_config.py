#!/usr/bin/env python
import sys
import os
import uuid
from time import sleep
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import json
import logging
import argparse
import tracker.model.analysis
import tracker.model.analysis_run
import tracker.model.configuration
from tracker.util import connection

def parse_args():
    my_parser = argparse.ArgumentParser()
    
    sub_parsers = my_parser.add_subparsers()
    
    create_configs_parser = sub_parsers.add_parser("create-configs", conflict_handler='resolve')
    create_configs_parser.add_argument("-a", "--analysis_id", help="ID of the analysis to run.", dest="analysis_id", required=True)
    create_configs_parser.add_argument("-n", "--num_runs", help="Number of runs to create configurations for.", dest="num_runs", required=True, type=int)
    create_configs_parser.add_argument("-t", "--tissue_type", help="Tumor or normal tissue", dest="tissue_type", choices = ["tumor", "normal"], required=True)
    create_configs_parser.add_argument("-c", "--config_location", help="Path to a directory where the generated config files will be stored.", dest="config_location", required=True)
    create_configs_parser.set_defaults(func=create_configs_command)
    
    my_args = my_parser.parse_args()
    
    return my_args

def get_available_samples(analysis_id, tissue_type, num_runs):
    
    PCAWGSample = connection.Base.classes.pcawg_samples
    SampleLocation = connection.Base.classes.sample_locations
    Analysis = connection.Base.classes.analysis
    AnalysisRun = connection.Base.classes.analysis_run
    Configuration = connection.Base.classes.configuration
    
    session = connection.Session()
    
    if tissue_type == "normal":
        sample_id = PCAWGSample.normal_wgs_alignment_gnos_id
        sample_location = SampleLocation.normal_sample_location
    else:
        sample_id = PCAWGSample.tumor_wgs_alignment_gnos_id
        sample_location = SampleLocation.tumor_sample_location
    
    current_runs = session.query(Configuration.config[("sample"," sample_id")].astext).\
        join(AnalysisRun, AnalysisRun.config_id == Configuration.config_id).\
        join(Analysis, Analysis.analysis_id == AnalysisRun.analysis_id).\
        filter(and_(Analysis.analysis_id == analysis_id, AnalysisRun.run_status != 4))
        
    available_samples = session.query(PCAWGSample.index.label("index"), sample_id.label("sample_id"), sample_location.label("sample_location")).\
        join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
        filter(and_(sample_location != None, sample_id.notin_(current_runs))).\
        limit(num_runs)
        
    session.close()
    connection.engine.dispose()
    
    return available_samples, int(available_samples.count())

def write_config_to_file(config, config_location):
    
    run_uuid = str(uuid.uuid4())
    
    my_file = open("{}/{}.json".format(config_location, run_uuid), "w")
    json.dump(config, my_file)
    my_file.close()

def generate_config_objects(available_samples, num_runs, config_location):
    for this_run in range(num_runs):
    
        
        this_config_data = {"sample": {
                                "donor_index": available_samples[this_run].index,
                                "sample_id": available_samples[this_run].sample_id,
                                "sample_location": available_samples[this_run].sample_location
                                }
                            }
        
        yield this_config_data
        

def create_configs_command(args):

    analysis_id = args.analysis_id
    num_runs = args.num_runs
    tissue_type = args.tissue_type
    config_location = args.config_location
    
    available_samples, num_available_samples = get_available_samples(analysis_id, tissue_type, num_runs)
    
    if num_available_samples < num_runs:
        print "Only found {} available samples to run. Will create {} run configurations.".format(str(num_available_samples), str(num_available_samples))
        num_runs = num_available_samples
    
    if (not os.path.isdir(config_location)):
        os.makedirs(config_location)
        
    for config in generate_config_objects(available_samples, num_runs, config_location):
        write_config_to_file(config, config_location)
    
if __name__ == '__main__':
    args = parse_args()
    args.func(args)
    

    
