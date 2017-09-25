patch_app_module:
  file.managed:
    - source: salt://airflow/config/app.py
    - name: /usr/lib/python2.7/site-packages/airflow/www/app.py
    - user: root
    - group: root
    - mode: 644