list_consul_members:
  salt.function:
    - tgt: 'salt-master'
    - name: cmd.run
    - arg:
      - consul members
      
test_postgres_service:
  salt.function:
    - tgt: 'roles:db-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service postgresql-9.5 status | grep running | wc -l) > 1 && /bin/true
      
test_postgres_service_name:
  salt.function:
    - tgt: 'roles:db-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts postgresql.service.consul | wc -l) > 0 && /bin/true

test_rabbitmq_service:
  salt.function:
    - tgt: 'roles:job-queue'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service rabbitmq-server status | grep running | wc -l) > 1 && /bin/true
      
test_rabbitmq_service_name:
  salt.function:
    - tgt: 'roles:job-queue'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts rabbitmq.service.consul | wc -l) > 0 && /bin/true
      
test_airflow_scheduler_service:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service airflow-scheduler status | grep running | wc -l) > 1 && /bin/true

test_airflow_webserver_service:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service airflow-webserver status | grep running | wc -l) > 1 && /bin/true
      
test_airflow_service_name:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts airflow.service.consul | wc -l) > 0 && /bin/true

test_airflow_worker_service:
  salt.function:
    - tgt: 'roles:worker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service airflow-worker status | grep running | wc -l) > 1 && /bin/true
      
test_influxdb_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service influxdb status | grep running | wc -l) > 1 && /bin/true
      
test_influxdb_service_name:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts influxdb.service.consul | wc -l) > 0 && /bin/true

test_grafana_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service grafana-server status | grep running | wc -l) > 1 && /bin/true
      
test_grafana_service_name:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts grafana.service.consul | wc -l) > 0 && /bin/true   
         
test_chronograf_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service chronograf status | grep running | wc -l) > 1 && /bin/true
      
test_kapacitor_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(service kapacitor status | grep running | wc -l) > 1 && /bin/true
      
test_telegraf_service:
  salt.function:
    - tgt: '*'
    - name: cmd.run
    - arg:
      - test $(service telegraf status | grep running | wc -l) > 1 && /bin/true