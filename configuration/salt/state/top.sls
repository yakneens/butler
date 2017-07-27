base:
  '*':
    - consul
    - dnsmasq
    - collectd
    - elastic.filebeat
    - elastic.packetbeat
    - ntp
  'G@roles:consul-bootstrap':
    - consul.bootstrap
  'G@roles:consul-server':
    - consul.server
    - consul.join-all
  'G@roles:consul-client':
    - consul.client
    - consul.join-all
  'G@roles:monitoring-server':
    - influxdb
    - grafana
    - kapacitor
  'G@roles:worker':
    - celery
    - airflow
    - airflow.worker
    - butler.tracker
    - butler.deploy.example-workflows
    - cwltool
    - docker    
  'G@roles:tracker':
    - run-tracking-db.set_db_url
    - celery
    - airflow
    - airflow.init-db
    - airflow.server
    - jsonmerge
    - butler.tracker
    - butler.deploy.example-workflows
  'G@roles:db-server':
    - postgres
    - run-tracking-db
    - run-tracking-db.create_tables
    - grafana.createdb
    - airflow.airflow-db
  'G@roles:job-queue':
    - rabbitmq
  'G@roles:elasticsearch':
    - elastic.search
    - elastic.logstash
    - elastic.kibana
    - celery
  'G@roles:R':
    - R  


  
    
  
    
    


    
