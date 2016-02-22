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

/data/germline_genotype_tracking/csv/pcawg_summary.tsv:
  file.managed:
    - source: salt://run-tracking-db/data/pcawg_summary.tsv
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
    - name: python /tmp/import_sample_data.py /data/germline_genotype_tracking/csv/pcawg_summary.tsv
    - user: postgres
    
add_sample_primary_key:
  cmd.run:
    - user: postgres
    - name: psql -d germline_genotype_tracking -c "ALTER TABLE pcawg_samples ADD PRIMARY KEY(index)"
    - unless: psql -t -d germline_genotype_tracking -c "SELECT count(*)  FROM pg_constraint co, pg_class cl WHERE co.conrelid=cl.oid AND cl.relname LIKE 'pcawg_samples' AND contype LIKE 'c'" | awk 'NF {print $1==0?"False":"True"}'
 