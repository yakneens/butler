run_tracking_db_airflow:
  postgres_database.present:
    - name: airflow
    - owner: butler_admin
    - tablespace: run_dbspace
    - user: postgres
    - db_host: localhost

run_tracking_db_celery:
  postgres_database.present:
    - name: celery
    - owner: butler_admin
    - tablespace: run_dbspace
    - user: postgres
    - db_host: localhost 