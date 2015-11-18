from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_
import datetime
import os

contig_names = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y"]

reference_location = "/reference/genome.fa"
variants_location = "/shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz"
results_base_path = "/shared/data/results/regenotype"



def lookup_sample_location(donor_index):
    Base = automap_base()
    engine = create_engine('postgresql://pcawg_admin:pcawg@postgresql.service.consul:5432/germline_genotype_tracking')
    Base.prepare(engine, reflect=True)
    
    SampleLocation = Base.classes.sample_locations
    
    session = Session(engine)

    my_sample_location = session.query(SampleLocation).filter(SampleLocation.donor_index==donor_index).first()

    if my_sample_location:
        return my_sample_location.normal_sample_location
    else:
        print "Sample location could not be found for donor: " + str(donor_index)
        exit(1)
        
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
    
    next_sample = session.query(PCAWGSample).\
        join(SampleLocation, PCAWGSample.index == SampleLocation.donor_index).\
        outerjoin(GenotypingRun,PCAWGSample.index == GenotypingRun.donor_index).\
        filter(\
               and_(SampleLocation.normal_sample_location != None, \
                    or_(GenotypingRun.run_status == None, GenotypingRun.run_status != 1)\
        )).\
        first()
    
    session.close()
    engine.dispose()

    if next_sample != None:
        return (next_sample.index, next_sample.normal_wgs_alignment_gnos_id)
    else:
        print "Could not find next sample"
        exit(1)

def reserve_sample():
    (donor_index, sample_id) = get_next_sample()
    os.system("python /tmp/germline-regenotyper/scripts/update-sample-status.py " + str(donor_index) + " " + sample_id + "1")
    return (donor_index, sample_id)
    

def set_error():
   os.system("/tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='reserve_sample')[0] }} {{ task_instance.xcom_pull(task_ids='reserve_sample')[1] }} 3")         

def run_freebayes(**kwargs):
    contig_name = kwargs["contig_name"]
    ti = kwargs["ti"]
    donor_index = ti.xcom_pull(task_ids='reserve_sample')[0]
    sample_id = ti.xcom_pull(task_ids='reserve_sample')[1]
    sample_location = lookup_sample_location(donor_index)
    result_path_prefix = "/shared/data/results/in_progress/" + sample_id
    if (not os.path.isdir(result_path_prefix)):
        os.makedirs(result_path_prefix)
    result_filename = result_path_prefix + "/" + sample_id + "_regenotype_" + contig_name + ".vcf"
    freebayes_command = "freebayes -r " + contig_name +\
                        " -f " + reference_location +\
                        " -@ " + variants_location +\
                        " -l " + sample_location +\
                        " > " + result_filename
    os.system(freebayes_command)
    
    generate_tabix(compress_sample(result_filename))
    copy_result(donor_index, sample_id)

def compress_sample(result_filename):
    compressed_filename = result_filename + ".gz"
    os.system("/usr/local/bin/bgzip -c " + result_filename + " > " + compressed_filename)
    return compressed_filename
      
def generate_tabix(compressed_filename):
    os.system("/usr/local/bin/tabix -f -p vcf " + compressed_filename)
         
    
def copy_result(donor_index, sample_id): 
    os.system('mkdir -p ' + results_base_path + '/' + sample_id + '/ && cp /tmp/' + sample_id + '_regenotype_' + contig_name + '.vcf.gz* "$_"')
        
        
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

dag = DAG("freebayes-regenotype", default_args=default_args,schedule_interval=None)


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
    




