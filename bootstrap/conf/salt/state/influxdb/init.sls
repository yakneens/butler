influxdb:
  pkg.installed:
    - sources:
      - influxdb: http://influxdb.s3.amazonaws.com/influxdb_0.9.2_amd64.deb
  service.running:
    - require:
      - pkg: influxdb
  
/var/lib/.influxdb:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/data:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/meta:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
/var/lib/.influxdb/hh:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644
    
/etc/opt/influxdb/influxdb.conf:
  file.managed:
    - source: salt://influxdb/config/influxdb.conf
    - user: influxdb
    - group: influxdb
    - mode: 644

influxdb_consul_config:
  file.managed:
    - name: /etc/consul.d/influxdb_consul.json
    - source: salt://influxdb/config/influxdb_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True    
