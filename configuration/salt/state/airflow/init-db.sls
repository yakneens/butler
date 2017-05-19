initialize_database:
  cmd.run:
    - name: airflow initdb
    - env:
      - AIRFLOW_CONFIG: '/etc/opt/airflow/airflow.cfg'
      - AIRFLOW_HOME: '/opt/airflow/'