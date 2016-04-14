grafana_db:
  postgres_database.present:
    - name: grafana
    - owner: butler_admin
    - tablespace: butler_dbspace
    - user: postgres

