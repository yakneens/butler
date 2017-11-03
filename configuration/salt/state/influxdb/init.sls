influxdb:
  pkg.installed:
    - sources:
      - influxdb: https://dl.influxdata.com/influxdb/releases/influxdb-1.3.7.x86_64.rpm
  service.running:
    - require:
      - pkg: influxdb
      - user: influxdb
    - watch:
      - file: /etc/influxdb/influxdb.conf
      
influxdb_user:
  user.present:
    - name: influxdb
    - home: /home/influxdb
    - gid_from_name: True
    - empty_password: True
  
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
/var/lib/.influxdb/wal:
  file.directory:
    - user: influxdb
    - group: influxdb
    - dir_mode: 755
    - file_mode: 644    
    
/etc/influxdb/influxdb.conf:
  file.managed:
    - source: salt://influxdb/config/influxdb.conf
    - user: influxdb
    - group: influxdb
    - mode: 644
    - template: jinja

influxdb_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/influxdb_consul.json
    - source: salt://influxdb/config/influxdb_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True    
  cmd.run:
    - name: systemctl restart consul