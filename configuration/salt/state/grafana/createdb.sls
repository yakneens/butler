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
    - owner: {{ pillar['postgres.user'] }}
    - directory: /data/grafana/db
    - user: postgres
    - db_host: localhost

grafana_indexspace:
  postgres_tablespace.present:
    - name: grafana_indexspace
    - owner: {{ pillar['postgres.user'] }}
    - directory: /data/grafana/indexes
    - user: postgres
    - db_host: localhost
     
grafana_db:
  postgres_database.present:
    - name: {{ pillar['grafana.db_name'] }}
    - owner: {{ pillar['postgres.user'] }}
    - tablespace: grafana_dbspace
    - user: postgres
    - db_host: localhost
