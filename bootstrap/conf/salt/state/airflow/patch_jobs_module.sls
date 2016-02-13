   
patch_jobs_module:
  file.managed:
    - source: salt://airflow/config/jobs.py
    - name: /usr/lib/python2.7/site-packages/airflow/jobs.py
    - user: root
    - group: root
    - mode: 644
    
patch_cli_module:
  file.managed:
    - source: salt://airflow/config/cli.py
    - name: /usr/lib/python2.7/site-packages/airflow/bin/cli.py
    - user: root
    - group: root
    - mode: 644