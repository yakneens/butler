airflow_home: /opt/airflow
airflow_config: /etc/opt/airflow/airflow.cfg
airflow_db_url: postgresql://{{ pillar.get('postgres.user') }}:{{ pillar.get('postgres.password') }}@{{ pillar.get('postgres.host') }}:{{ pillar.get('postgres.port') }}/airflow
airflow_web_server_port: 8889
airflow_celery_db_url: postgresql://{{ pillar.get('postgres.user') }}:{{ pillar.get('postgres.password') }}@{{ pillar.get('postgres.host') }}:{{ pillar.get('postgres.port') }}/celery
airflow_worker_concurrency: 8
airflow_job_queue_url: {{ pillar.get('rabbitmq.amqp_url') }}
