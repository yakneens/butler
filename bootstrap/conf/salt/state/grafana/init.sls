initscripts:
  pkg.installed: []

fontconfig:
  pkg.installed: []

grafana:
  pkg.installed:
    - sources:
      - grafana: https://grafanarel.s3.amazonaws.com/builds/grafana-2.1.3-1.x86_64.rpm
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

http://grafana.service.consul:3000/api/datasources:
  http.query:
    - method: 'POST'
    - status: '200'
    - username: 'admin'
    - password: 'admin'
    - data_render: True
    - header_dict: {'Accept':'application/json', 'Content-Type':'application/json'}
    - data_file: salt://grafana/config/metrics_data_source.json
    - header_render: True
    - cookies: True
    - persist_session: True
    
 