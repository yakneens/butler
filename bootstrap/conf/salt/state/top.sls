base:
  '*':
    - consul
    - dnsmasq
    - collectd
#    - hostfile
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
  'G@roles:tracker':
    - postgres
    - run-tracking-db
    - rabbitmq
    - celery
    - airflow
  'G@roles:glusterfs-server':
    - gluster
    - gluster.bricks
  'G@roles:glusterfs-master':
    - gluster

    