grafana_db:
  postgres_database.present:
    - name: grafana
    - owner: pcawg_admin
    - tablespace: germline_dbspace
    - user: postgres

