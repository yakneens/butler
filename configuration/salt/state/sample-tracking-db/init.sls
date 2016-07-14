pcawg_admin_user:
  postgres_user.present:
    - name: pcawg_admin
    - createdb: True
    - superuser: True
    - password: pcawg
    - user: postgres

pcawg_user:
  postgres_user.present:
    - name: pcawg
    - password: pcawg
    - user: postgres

    
/data/pcawg_sample_tracking/db:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
/data/pcawg_sample_tracking/indexes:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
pcawg_tablespace:
  postgres_tablespace.present:
     - name: pcawg_sample_dbspace
     - owner: pcawg_admin
     - directory: /data/pcawg_sample_tracking/db
     - user: postgres

pcawg_indexspace:
  postgres_tablespace.present:
     - name: pcawg_sample_indexspace
     - owner: pcawg_admin
     - directory: /data/pcawg_sample_tracking/indexes
     - user: postgres

pcawg_sample_db:
  postgres_database.present:
    - name: pcawg_sample_tracking
    - owner: pcawg_admin
    - tablespace: pcawg_sample_dbspace
    - user: postgres
    