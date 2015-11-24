from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import datetime
import os
import logging
from logging.config import dictConfig
from logging.handlers import RotatingFileHandler
from subprocess import call

logging_config = dict(
    version = 1,
    disable_existing_loggers = False,
    formatters = {
        'f': {'format':
              '%(asctime)s %(name)-12s %(levelname)-8s %(message)s'}
        },
    handlers = {
        'h': {'class': 'logging.handlers.RotatingFileHandler',
              'formatter': 'f',
              'level': logging.DEBUG,
              'maxBytes': 100000000,
              'backupCount': 10,
              'filename': '/tmp/freebayes-regenotype-workflow.log'}
        },
    loggers = {
        'root': {'handlers': ['h'],
                 'level': logging.DEBUG}
        }
)

dictConfig(logging_config)
logger = logging.getLogger()

contig_names = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y"]

reference_location = "/reference/genome.fa"
variants_location = "/shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz"
results_base_path = "/shared/data/results/regenotype"

def set_ready(my_run):
    if my_run.run_status == 1:
        print "Cannot put a run that's In Progress into a Ready status"
        
        logger.error("Attempting to put an In Progress run into Ready state, runID: %d", my_run.run_id)
        
        exit(1)
    else:
        my_run.run_status = 0
        
def set_in_progress(my_run):
    if my_run.run_status != 0:
        
        logger.error("Wrong run status - %d, Only a Ready run can be put In Progress, runID: %d", my_run.run_status, my_run.run_id)
        exit(1)
    else:
        my_run.run_status = 1
        my_run.run_start_date = datetime.datetime.now()
        
def set_finished(my_run):
    if my_run.run_status != 1:
        
        logger.error("Wrong run status - %d, Only an In Progress run can be Finished, runID: %d", my_run.run_status, my_run.run_id)
        exit(1)
    else:
        my_run.run_status = 2
        my_run.run_end_date = datetime.datetime.now()
        
def set_error(my_run):
    my_run.run_status = 3

set_status = {"0": set_ready, "1": set_in_progress, "2": set_finished, "3": set_error}

def update_run_status(donor_index, sample_id, run_status):
    Base = automap_base()
    engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
    Base.prepare(engine, reflect=True)
    
    PCAWGSample = Base.classes.pcawg_samples
    SampleLocation = Base.classes.sample_locations
    GenotypingRun = Base.classes.genotyping_runs
    
    session = Session(engine)
    
    this_donor_index = donor_index
    this_sample_id = sample_id
    new_status = run_status
    
    my_run = session.query(GenotypingRun).filter(and_(GenotypingRun.donor_index==this_donor_index, GenotypingRun.sample_id==this_sample_id)).first()
    
    if not my_run:
        my_run = GenotypingRun()
        my_run.run_status = 0
        my_run.donor_index = this_donor_index
        my_run.sample_id = this_sample_id
        my_run.created_date = datetime.datetime.now()
        
        logger.info("No Genotyping Run found for donor %d. Creating new Genotyping Run", my_run.donor_index)
        
        session.add(my_run)
    
    set_status[new_status](my_run)
    my_run.last_updated_date = datetime.datetime.now()
    
    logger.info("Setting run status for donor %d to %d", my_run.donor_index, new_status)
    
    session.commit()
    session.close()
    engine.dispose()

def get_next_sample():    
    Base = automap_base()
    engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
    Base.prepare(engine, reflect=True)
    
    PCAWGSample = Base.classes.pcawg_samples
    SampleLocation = Base.classes.sample_locations
    GenotypingRun = Base.classes.genotyping_runs
    
    session = Session(engine)
    
    
    logger.debug("Getting next available sample")
    
    session.begin()
    
    next_sample = session.query(PCAWGSample.index, PCAWGSample.normal_wgs_alignment_gnos_id, SampleLocation.normal_sample_location, GenotypingRun.run_id).\
        join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
        outerjoin(GenotypingRun,PCAWGSample.index == GenotypingRun.donor_index).\
        filter(\
               and_(SampleLocation.normal_sample_location != None, \
                    or_(GenotypingRun.run_status == None, and_(GenotypingRun.run_status != 1, GenotypingRun.run_status != 2))\
        )).\
        with_for_update().\
        first()
    
    my_run_id = next_sample.run_id    
    donor_index = next_sample.index
    sample_id = next_sample.normal_wgs_alignment_gnos_id
    sample_location = next_sample.normal_sample_location
    
    logger.info("Got the next available sample Donor Index: %d, Sample ID: %s, Sample Location: %s, Genotyping Run: %d.", donor_index, sample_id, sample_location, my_run_id)
    
    
    my_run = None
    
    if not my_run_id:
        my_run = GenotypingRun()
        my_run.run_status = 0
        my_run.donor_index = donor_index
        my_run.sample_id = sample_id
        my_run.created_date = datetime.datetime.now()
        
        logger.info("No Genotyping Run found for donor %d. Creating new Genotyping Run", my_run.donor_index)
        
        
        session.add(my_run)
    else:
        my_run = session.query(GenotypingRun).get(my_run_id)
    
    set_status["1"](my_run)
    my_run.last_updated_date = datetime.datetime.now()
    
    logger.info("Setting run status for donor %d to In Progress", my_run.donor_index)
    
    session.commit()
    session.close()
    engine.dispose()

    if next_sample != None:
        return (donor_index, sample_id, sample_location)
    else:
        logger.error("Could not find the next sample")
        exit(1)

def reserve_sample():
    return get_next_sample()
    

def set_error():
   logger.info("Setting error state for run.")
   os.system("/tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='reserve_sample')[0] }} {{ task_instance.xcom_pull(task_ids='reserve_sample')[1] }} 3")         

def run_freebayes(**kwargs):
    contig_name = kwargs["contig_name"]
    ti = kwargs["ti"]
    
    donor_index = ti.xcom_pull(task_ids='reserve_sample')[0]
    sample_id = ti.xcom_pull(task_ids='reserve_sample')[1]
    sample_location = ti.xcom_pull(task_ids='reserve_sample')[2]
    logger.info("Got sample assignment from the sample reservation task: %d %s %s", donor_index, sample_id, sample_location)
    
    
    result_path_prefix = "/tmp/" + sample_id
    
    if (not os.path.isdir(result_path_prefix)):
        logger.info("Results directory %s not present, creating.", result_path_prefix)
        os.makedirs(result_path_prefix)
    
    result_filename = result_path_prefix + "/" + sample_id + "_regenotype_" + contig_name + ".vcf"
    
    
    freebayes_command = "/bin/freebayes -r " + contig_name +\
                        " -f " + reference_location +\
                        " -@ " + variants_location +\
                        " -l " + sample_location +\
                        " > " + result_filename
    
    logger.info("About to invoke freebayes with command %s.", freebayes_command)
    #os.system(freebayes_command)
    try:
        retcode = call(freebayes_command)
        if retcode < 0:
            logger.error("Freebayes terminated by signal %d.", retcode)
        else:
            logger.info("Freebayes terminated normally.")
    except OSError as e:
        logger.error("Freebayes execution failed %s.", e)
        
    generate_tabix(compress_sample(result_filename))
    copy_result(donor_index, sample_id, contig_name)

def compress_sample(result_filename):
    compressed_filename = result_filename + ".gz"
    compression_command = "/usr/local/bin/bgzip -c " + result_filename + " > " + compressed_filename
    
    logger.info("About to compress sample %s. Using command: %s.", result_filename, compression_command)
    #os.system(compression_command)
    try:
        retcode = call(compression_command)
        if retcode < 0:
            logger.error("Compression terminated by signal %d.", retcode)
        else:
            logger.info("Compression terminated normally.")
    except OSError as e:
        logger.error("Compression failed %s.", e)
    
    
    return compressed_filename
      
def generate_tabix(compressed_filename):
    tabix_command = "/usr/local/bin/tabix -f -p vcf " + compressed_filename
    
    logger.info("About to generate tabix for %s. Using command: %s.", compressed_filename, tabix_command)
    
    #os.system(tabix_command)
    try:
        retcode = call(tabix_command)
        if retcode < 0:
            logger.error("Tabix generation terminated by signal %d.", retcode)
        else:
            logger.info("Tabix generation terminated normally.")
    except OSError as e:
        logger.error("Tabix generation failed %s.", e)
    
    
         
    
def copy_result(donor_index, sample_id, contig_name): 
    results_directory_command = "mkdir -p " + results_base_path + "/" + sample_id
    #os.system(results_directory_command)
    try:
        retcode = call(results_directory_command)
        if retcode < 0:
            logger.error("Results directory creation terminated by signal %d.", retcode)
    except OSError as e:
        logger.error("Results directory creation failed %s.", e)
    
    copy_command = "cp /tmp/" + sample_id + "/" + sample_id + "_regenotype_" + contig_name + ".vcf.gz* " + results_base_path + "/" + sample_id + "/"
    logger.info("About to copy results for %d %s to shared storage. Using command '%s'", donor_index, sample_id, copy_command)
    
    #os.system(copy_command)
    try:
        retcode = call(copy_command)
        if retcode < 0:
            logger.error("Results copying terminated by signal %d.", retcode)
        else:
            logger.info("Results copying terminated normally.")
    except OSError as e:
        logger.error("Results copying failed %s.", e)
     
        
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime.datetime(2020,01,01),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG("freebayes-regenotype", default_args=default_args,schedule_interval=None,concurrency=1000,max_active_runs=1000)


reserve_sample_task = PythonOperator(
    task_id = "reserve_sample",
    python_callable = reserve_sample,
    dag = dag)

release_sample_task = BashOperator(
    task_id = "release_sample",
    bash_command = "python /tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='reserve_sample')[0] }} {{ task_instance.xcom_pull(task_ids='reserve_sample')[1] }} 2",
    dag = dag)

for contig_name in contig_names:
    genotyping_task = PythonOperator(
       task_id = "regenotype_" + contig_name,
       python_callable = run_freebayes,
       op_kwargs={"contig_name": contig_name},
       provide_context=True,
       dag = dag)
    
    genotyping_task.set_upstream(reserve_sample_task)
    
    release_sample_task.set_upstream(genotyping_task)