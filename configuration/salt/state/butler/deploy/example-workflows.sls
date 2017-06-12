/opt/airflow/dags/example-workflows:
  file.symlink:
    - target: /opt/butler/examples/workflows
    - user: airflow
    - group: airflow
    - mode: 755
    - force: True
    - makedirs: True