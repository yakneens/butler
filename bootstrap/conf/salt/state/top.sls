base:
  '*':
    - consul
    - dnsmasq
    - collectd
    - elastic.filebeat
    - elastic.packetbeat
  'G@roles:consul-bootstrap':
    - consul.bootstrap
  'G@roles:consul-server':
    - consul.server
  'G@roles:consul-client':
    - consul.client
  'G@roles:monitoring-server':
    - influxdb
    - grafana 
  'G@roles:genotyper':
    - dnsmasq.gnos
    - biotools.freebayes
    - biotools.htslib
    - biotools.samtools
    - celery
    - airflow
    - airflow.load-workflows
    - airflow.worker
  'G@roles:tracker':
    - elastic.search
    - elastic.logstash
    - elastic.kibana
    - postgres
    - grafana.createdb
    - run-tracking-db
    - rabbitmq
    - celery
    - airflow
    - airflow.load-workflows
    - airflow.server


    