airflow_home: /opt/airflow
airflow_config: /etc/opt/airflow/airflow.cfg
airflow_db_url: postgresql://{{ pillar['postgres.user'] }}:{{ pillar['postgres.password'] }}@{{ pillar['postgres.host'] }}:{{ pillar['postgres.port'] }}/airflow
airflow_web_server_port: 8889
airflow_celery_db_url: postgresql://{{ pillar['postgres.user'] }}:{{ pillar['postgres.password'] }}@{{ pillar['postgres.host'] }}:{{ pillar['postgres.port'] }}/celery
airflow_worker_concurrency: 8
airflow_job_queue_url: {{ pillar['rabbitmq.amqp_url'] }}
