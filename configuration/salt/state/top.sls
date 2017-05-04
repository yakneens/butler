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
  'G@roles:consul-client':
    - consul.client
  'G@roles:monitoring-server':
    - influxdb
    - grafana 
  'G@roles:worker':
    - dnsmasq.gnos
    - celery
    - airflow
    - airflow.worker
    - airflow.patch-airflow-db-conns
    - butler.tracker
    - cwltool
    - docker    
  'G@roles:tracker':
    - airflow
    - airflow.patch-airflow-db-conns
    - airflow.server
    - jsonmerge
    - butler.tracker
  'G@roles:db-server':
    - postgres
    - run-tracking-db
    - run-tracking-db.create_tables
    - grafana.createdb
    - airflow.airflow-db
  'G@roles:job-queue':
    - rabbitmq
    - rabbitmq-config
  'G@roles:elasticsearch':
    - elastic.search
    - elastic.logstash
    - elastic.kibana
    - celery
  'G@roles:R':
    - R  


  
    
  
    
    


    
