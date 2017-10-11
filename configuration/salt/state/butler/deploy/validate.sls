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
      - test $(systemctl status postgresql-9.5 | grep running | wc -l) -gt 0 && /bin/true
      
test_postgres_service_name:
  salt.function:
    - tgt: 'roles:db-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts postgresql.service.consul | wc -l) -gt 0 && /bin/true

test_rabbitmq_service:
  salt.function:
    - tgt: 'roles:job-queue'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status rabbitmq-server | grep running | wc -l) -gt 0 && /bin/true
      
test_rabbitmq_service_name:
  salt.function:
    - tgt: 'roles:job-queue'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts rabbitmq.service.consul | wc -l) -gt 0 && /bin/true
      
test_airflow_scheduler_service:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status airflow-scheduler | grep running | wc -l) -gt 0 && /bin/true

test_airflow_webserver_service:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status airflow-webserver | grep running | wc -l) -gt 0 && /bin/true
      
test_airflow_service_name:
  salt.function:
    - tgt: 'roles:tracker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts airflow.service.consul | wc -l) -gt 0 && /bin/true

test_airflow_worker_service:
  salt.function:
    - tgt: 'roles:worker'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status airflow-worker | grep running | wc -l) -gt 0 && /bin/true
      
test_influxdb_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status influxdb | grep running | wc -l) -gt 0 && /bin/true
      
test_influxdb_service_name:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts influxdb.service.consul | wc -l) -gt 0 && /bin/true

test_grafana_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status grafana-server | grep running | wc -l) -gt 0 && /bin/true
      
test_grafana_service_name:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(getent hosts grafana.service.consul | wc -l) -gt 0 && /bin/true   
         
test_chronograf_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status chronograf | grep running | wc -l) -gt 0 && /bin/true
      
test_kapacitor_service:
  salt.function:
    - tgt: 'roles:monitoring-server'
    - tgt_type: grain
    - name: cmd.run
    - arg:
      - test $(systemctl status kapacitor | grep running | wc -l) -gt 0 && /bin/true
      
test_telegraf_service:
  salt.function:
    - tgt: '*'
    - name: cmd.run
    - arg:
      - test $(systemctl status telegraf | grep running | wc -l) -gt 0 && /bin/true