/opt/airflow/dags/example-workflows:
  file.symlink:
    - target: /opt/butler/examples/workflows
    - user: airflow
    - group: airflow
    - mode: 755
    - force: True
    - makedirs: True

{% if "tracker" in grains['roles'] %}    
ew_restart_airflow_scheduler:
  cmd.run:
    - name: service airflow-scheduler restart

ew_restart_airflow_webserver:
  cmd.run:
    - name: service airflow-webserver restart
{% endif %}