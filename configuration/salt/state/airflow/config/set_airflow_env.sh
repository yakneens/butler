export AIRFLOW_HOME=/opt/airflow/
export AIRFLOW_CONFIG=/etc/opt/airflow/airflow.cfg
export DB_URL={{ pillar['run_tracking_db_url'] }}