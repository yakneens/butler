back_up_jobs_module:
  cmd.run:
    - name: cp /usr/lib/python2.7/site-packages/airflow/jobs.py /tmp/jobs.py
    
patch_jobs_module:
  file.managed:
    - src: salt://airflow/config/jobs.py
    - name: /usr/lib/python2.7/site-packages/airflow/jobs.py
    - user: root
    - group: root
    - mode: 644