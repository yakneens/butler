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

    
/data/germline_genotype_tracking/db:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
/data/germline_genotype_tracking/indexes:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
pcawg_tablespace:
  postgres_tablespace.present:
     - name: germline_dbspace
     - owner: pcawg_admin
     - directory: /data/germline_genotype_tracking/db
     - user: postgres

pcawg_indexspace:
  postgres_tablespace.present:
     - name: germline_indexspace
     - owner: pcawg_admin
     - directory: /data/germline_genotype_tracking/indexes
     - user: postgres

pcawg_sample_db:
  postgres_database.present:
    - name: germline_genotype_tracking
    - owner: pcawg_admin
    - tablespace: germline_dbspace
    - user: postgres
    