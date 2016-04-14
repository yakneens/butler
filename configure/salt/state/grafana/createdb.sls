/data/grafana/db:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
/data/grafana/indexes:
  file.directory:
    - user: postgres
    - group: postgres
    - mode: 744
    - makedirs: True
    
grafana_tablespace:
  postgres_tablespace.present:
     - name: grafana_dbspace
     - owner: butler_admin
     - directory: /data/grafana/db
     - user: postgres

butler_indexspace:
  postgres_tablespace.present:
     - name: grafana_indexspace
     - owner: butler_admin
     - directory: /data/grafana/indexes
     - user: postgres

grafana_db:
  postgres_database.present:
    - name: grafana
    - owner: butler_admin
    - tablespace: grafana_dbspace
    - user: postgres

