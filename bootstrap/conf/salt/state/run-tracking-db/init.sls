run_tracking_db_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/run_tracking_db_consul.json
    - source: salt://run-tracking-db/config/run_tracking_db_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True

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

pandas:
  cmd.run:
    - name: pip install pandas
sqlalchemy:
  cmd.run:
    - name: pip install sqlalchemy   
     
python-psycopg2:
  pkg.installed:
    - name: python-psycopg2

/data/germline_genotype_tracking/csv:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True

/data/germline_genotype_tracking/csv/pcawg_sample_list_august_2015.csv:
  file.managed:
    - source: salt://run-tracking-db/data/pcawg_sample_list_august_2015.csv
    - user: postgres
    - group: postgres
    - mode: 644

/tmp/import_sample_data.py:
  file.managed:
    - source: salt://run-tracking-db/scripts/import_sample_data.py
    - user: postgres
    - group: postgres
    - mode: 744
    
import_sample_data:
  cmd.run:
    - name: python /tmp/import_sample_data.py /data/germline_genotype_tracking/csv/pcawg_sample_list_august_2015.csv
    - user: postgres
 
