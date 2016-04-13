initscripts:
  pkg.installed: []

fontconfig:
  pkg.installed: []
  
grafana:
  pkg.installed:
    - sources:
      - grafana: https://grafanarel.s3.amazonaws.com/builds/grafana-3.0.0-beta31460467884%C2%A7.x86_64.rpm
  service.running:
    - name: grafana-server
    - require:
      - pkg: grafana
    - watch:
      - file: /etc/grafana/grafana.ini
      - file: /var/lib/grafana/dashboards/*

grafana_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/grafana_consul.json
    - source: salt://grafana/config/grafana_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 

/etc/grafana/grafana.ini:
  file.managed:
    - source: salt://grafana/config/grafana.ini
    - user: root
    - group: root
    - mode: 644
    
/var/lib/grafana/dashboards:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

/var/lib/grafana/dashboards/:
  file.recurse:
    - source: salt://grafana/dashboards/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

create_data_source:
  cmd.run:
    - name: curl --user admin:admin 'http://grafana.service.consul:3000/api/datasources' -X POST --data-binary '{"name":"metrics","type":"influxdb","Url":"http://influxdb.service.consul:8086","Access":"proxy","isDefault":true,"Database":"metrics","User":"root","Password":"root"}' -H Content-Type:application/json --noproxy grafana.service.consul
    
 