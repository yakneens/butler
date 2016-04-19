run_tracking_db_airflow:
  postgres_database.present:
    - name: airflow
    - owner: butler_admin
    - tablespace: run_dbspace
    - user: postgres

run_tracking_db_celery:
  postgres_database.present:
    - name: celery
    - owner: butler_admin
    - tablespace: run_dbspace
    - user: postgres
  