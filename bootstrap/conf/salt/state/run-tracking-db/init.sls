add_pcawg_admin_user:
  cmd.run:
    - user: postgres
    - name: psql -c "CREATE USER pcawg_admin WITH PASSWORD 'pcawg'"
pcawg_admin_grant_createdb:
  cmd.run:
    - user: postgres
    - name: psql -c "ALTER USER pcawg_admin CREATEDB"
pcawg_admin_grant_superuser:
  cmd.run:
    - user: postgres
    - name: psql -c "GRANT postgres TO pcawg_admin"
add_pcawg_user:
  cmd.run:
    - user: postgres
    - name: psql -c "CREATE USER pcawg WITH PASSWORD 'pcawg'"
    
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
    
create_pcawg_tablespace:
  cmd.run:
    - user: postgres
    - name: psql -c "CREATE TABLESPACE germline_dbspace OWNER pcawg_admin LOCATION '/data/germline_genotype_tracking/db'"    

create_pcawg_indexspace:
  cmd.run:
    - user: postgres
    - name: psql -c "CREATE TABLESPACE germline_indexspace OWNER pcawg_admin LOCATION '/data/germline_genotype_tracking/indexes'"    

create_pcawg_sample_db:
  cmd.run:
    - user: postgres
    - name: psql -c "CREATE DATABASE germline_genotype_tracking OWNER pcawg_admin TABLESPACE germline_dbspace"

pandas:
  cmd.run:
    - name: pip install pandas
sqlalchemy:
  cmd.run:
    - name: pip install sqlalchemy    
