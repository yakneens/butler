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
    create_configs_parser.add_argument("-n", "--num_runs", help="Number of runs to create configurations for.", dest="num_runs", required=True)
    create_configs_parser.add_argument("-t", "--tissue_type", help="Tumor or normal tissue", dest="tissue_type", choices = ["tumor", "normal"], required=True)
    create_configs_parser.add_argument("-c", "--config_location", help="Path to a directory where the generated config files will be stored.", dest="config_location", required=True)
    create_configs_parser.set_defaults(func=create_configs_command)
    
    my_args = my_parser.parse_args()
    
    return my_args

if __name__ == '__main__':
    args = parse_args()
    args.func(args)
    
def create_configs_command(args):

    analysis_id = args.analysis_id
    num_runs = args.num_runs
    tissue_type = args.tissue_type
    config_location = args.config_location
    
    PCAWGSample = conection.Base.classes.pcawg_samples
    SampleLocation = conection.Base.classes.sample_locations
    Analysis = conection.Base.classes.analysis
    AnalysisRun = conection.Base.classes.aalysis_run
    Configuration = conection.Base.classes.configuration
    
    session = connection.Session()
    
    if tissue_type == "normal":
        sample_id = PCAWGSample.normal_wgs_alignment_gnos_id
        sample_location = SampleLocation.normal_sample_location
    else:
        sample_id = PCAWGSample.tumor_wgs_alignment_gnos_id
        sample_location = SampleLocation.tumor_sample_location
    
    # There is a bug in this query. If two analysis runs exist for the same sample one in error and one running
    # That sample will be scheduled again.        
    available_samples = session.query(PCAWGSample.index, sample_id, sample_location, AnalysisRun.analysis_run_id).\
        join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
        join(Analysis, analysis_id == Analysis.analysis_id).\
        outerjoin(AnalysisRun, AnalysisRun.analysis_id == analysis_id).\
        join(Configuration, and_(Configuration.config_id == AnalysisRun.config_id, Configuration.config.sample.sample_id == sample_id)).\
        filter(
        and_(sample_location != None,
             or_(AnalysisRun.run_status == None, AnalysisRun.run_status == AnalysisRun.RUN_STATUS_ERROR)
             )).\
        limit(num_runs)
        
    session.commit()
    
    num_available_samples = len(available_samples)
    
    if num_available_samples < num_runs:
        print "Only found {} available samples to run. Will create {} run configurations.".format(str(num_available_samples), str(num_available_samples))
        num_runs = num_available_samples
    
    for this_run in range(num_runs):
    
        run_uuid = str(uuid.uuid4())
    
        this_config_data = {"sample": {
                                "donor_index": available_samples[this_run].index,
                                "sample_id": available_samples[this_run].sample_id,
                                "sample_location": available_samples[this_run].sample_location
                                }
                            }
        
        if (not os.path.isdir(config_location)):
            os.makedirs(config_location)
        
        my_file = open("{}/{}.josn".format(config_location, run_uuid), "w")
        json.dump(this_config_data, my_file)
        my_file.close()
    

    
