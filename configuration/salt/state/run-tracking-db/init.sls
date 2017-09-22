butler_admin_user:
  postgres_user.present:
    - name: {{ pillar['postgres.user'] }}
    - createdb: True
    - superuser: True
    - password: {{ pillar['postgres.password'] }}
    - user: postgres
    - db_host: localhost
    - db_user: postgres
    - maintenance_db: postgres

    
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
    - owner: {{ pillar['postgres.user'] }}
    - directory: /data/run_tracking/db
    - user: postgres
    - db_host: localhost
    - db_user: postgres
    - maintenance_db: postgres

butler_indexspace:
  postgres_tablespace.present:
    - name: run_indexspace
    - owner: {{ pillar['postgres.user'] }}
    - directory: /data/run_tracking/indexes
    - user: postgres
    - db_host: localhost
    - db_user: postgres
    - maintenance_db: postgres

run_tracking_db:
  postgres_database.present:
    - name: {{ pillar['run_tracking_db_name'] }}
    - owner: {{ pillar['postgres.user'] }}
    - tablespace: run_dbspace
    - user: postgres
    - db_host: localhost
    - db_user: postgres
    - maintenance_db: postgres
    