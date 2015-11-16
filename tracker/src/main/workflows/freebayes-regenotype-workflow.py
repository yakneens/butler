from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine
from sqlalchemy import or_, and_

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

def set_error():
   os.system("/tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[0] }} {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[1] }} 3")         
    
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 11, 9),
    'email': ['airflow@airflow.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
}

# Commenting out full list of contigs for now leaving only 1-22, X, Y
#contig_names = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y","MT","GL000207.1","GL000226.1","GL000229.1","GL000231.1","GL000210.1","GL000239.1","GL000235.1","GL000201.1","GL000247.1","GL000245.1","GL000197.1","GL000203.1","GL000246.1","GL000249.1","GL000196.1","GL000248.1","GL000244.1","GL000238.1","GL000202.1","GL000234.1","GL000232.1","GL000206.1","GL000240.1","GL000236.1","GL000241.1","GL000243.1","GL000242.1","GL000230.1","GL000237.1","GL000233.1","GL000204.1","GL000198.1","GL000208.1","GL000191.1","GL000227.1","GL000228.1","GL000214.1","GL000221.1","GL000209.1","GL000218.1","GL000220.1","GL000213.1","GL000211.1","GL000199.1","GL000217.1","GL000216.1","GL000215.1","GL000205.1","GL000219.1","GL000224.1","GL000223.1","GL000195.1","GL000212.1","GL000222.1","GL000200.1","GL000193.1","GL000194.1","GL000225.1","GL000192.1","NC_007605","hs37d5"]
contig_names = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","X","Y"]

#donor_index = "23"
#sample_id = "f87f8019-db9f-46d0-9e39-d16a37646815"
reference_location = "/reference/genome.fa"
variants_location = "/shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz"
results_base_path = "/shared/data/results/regenotype"

dag = DAG("freebayes-regenotype", default_args=default_args)


get_sample_assignment_task = PythonOperator(
    task_id = "get_sample_assignment",
    python_callable = get_next_sample(),
    dag = dag)

reserve_sample_task = BashOperator(
    task_id = "reserve_sample",
    bash_command = "python  /tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[0] }} {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[1] }} 1",
    dag = dag)

reserve_sample_task.set_upstream(get_sample_assignment_task)

release_sample_task = BashOperator(
    task_id = "release_sample",
    bash_command = "python /tmp/germline-regenotyper/scripts/update-sample-status.py {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[0] }} {{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[1] }} 2",
    dag = dag)

for contig_name in contig_names:
    sample_location = lookup_sample_location({{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[0] }})
    result_filename = "/tmp/{{ task_instance.xcom_pull(task_ids='get_sample_assignment_task')[1] }}_regenotype_" + contig_name + ".vcf"
    genotyping_task = BashOperator(
       task_id = "regenotype_" + contig_name,
       bash_command = "freebayes -r " + contig_name +\
                        " -f " + reference_location +\
                        " -@ " + variants_location +\
                        " -l " + sample_location +\
                        " > " + result_filename,
       dag = dag)
    
    genotyping_task.set_upstream(reserve_sample_task)
    
    data_compress_task = BashOperator(                                  
        task_id = "compress_result_" + contig_name,
        bash_command = '/usr/local/bin/bgzip -c ' + result_filename + ' > ' + result_filename + '.gz',
        dag = dag)
    
    data_compress_task.set_upstream(genotyping_task)
    
    generate_tabix_task = BashOperator(                                  
        task_id = "generate_tabix_" + contig_name,
        bash_command = '/usr/local/bin/tabix -f -p vcf ' + result_filename + '.gz',
        dag = dag)
    
    generate_tabix_task.set_upstream(data_compress_task)
    
    data_copy_task = BashOperator(                                  
        task_id = "copy_result_" + contig_name,
        bash_command = 'mkdir -p ' + results_base_path + '/{{ task_instance.xcom_pull(task_ids="get_sample_assignment_task")[1] }}/ && cp /tmp/{{ task_instance.xcom_pull(task_ids="get_sample_assignment_task")[0] }}_regenotype_' + contig_name + '.vcf.gz* "$_"',
        dag = dag)
    
    data_copy_task.set_upstream(generate_tabix_task)
    
    release_sample_task.set_upstream(data_copy_task)
    




