base:
  '*':
    - saltmine
    - collectd
    - postgres
    - rabbitmq
    - influxdb
  'G@roles:worker':
    - test-data
    - run-tracking-db
    - airflow
  'G@roles:tracker':
    - run-tracking-db
    - airflow
  'G@roles:monitoring-server':
    - grafana
    - kapacitor
  'G@roles:db-server':
    - grafana
    - run-tracking-db
  'G@roles:butler-web':
    - butler
  'G@roles:consul-server':
      - consul.server   
  'G@roles:single-node':
    - consul.single_node

