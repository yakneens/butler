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
  'G@roles:db-server':
    - grafana

