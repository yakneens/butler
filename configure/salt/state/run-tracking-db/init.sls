pcawg_admin_user:
  postgres_user.present:
    - name: butler_admin
    - createdb: True
    - superuser: True
    - password: butler
    - user: postgres

pcawg_user:
  postgres_user.present:
    - name: butler
    - password: butler
    - user: postgres

    
/data/run_tracking/db:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
/data/run_tracking/indexes:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
run_tablespace:
  postgres_tablespace.present:
     - name: run_dbspace
     - owner: butler_admin
     - directory: /data/run_tracking/db
     - user: postgres

butler_indexspace:
  postgres_tablespace.present:
     - name: run_indexspace
     - owner: butler_admin
     - directory: /data/run_tracking/indexes
     - user: postgres

run_tracking_db:
  postgres_database.present:
    - name: run_tracking
    - owner: butler_admin
    - tablespace: run_dbspace
    - user: postgres
    