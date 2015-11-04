from airflow import DAG
from airflow.operators import BashOperator, PythonOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
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


donor_index = "23"
sample_id = "f82d213f-bc96-5b1d-e040-11ac0c486880"

dag = DAG("freebayes-regenotype", default_args=default_args)

t1 = BashOperator(
    task_id = "reserve_sample",
    bash_command = "su - postgres -c \"python /tmp/update-sample-status.py " + donor_index + " "  + sample_id + " 1\"",
    dag = dag)











