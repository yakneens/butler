set_db_url:
   environ.setenv:
     - name: DB_URL
     - value: postgresql://butler_admin:butler@postgresql.service.consul:5432/run_tracking
     - update_minion: True