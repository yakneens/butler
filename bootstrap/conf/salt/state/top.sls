base:
  '*':
    - consul
    - dnsmasq
    - collectd
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
    - airflow
    - airflow.load-workflows
  'G@roles:tracker':
    - logstash
    - postgres
    - grafana.createdb
    - run-tracking-db
    - rabbitmq
    - celery
    - airflow
    - airflow.load-workflows
    - airflow.server


    