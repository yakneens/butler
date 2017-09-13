/opt/kibana:
  archive.extracted:
    - source: https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz
    - archive_format: tar
    - tar_options: z
    - source_hash: sha1=ff3653824735edff3201761f584729b2d0cd0216

/usr/lib/systemd/system/kibana.service:
  file.managed:
    - source: salt://elastic/kibana/config/kibana.service
    - user: root
    - group: root
    - mode: 744
    - makedirs: True

/etc/opt/kibana/kibana.yml:
  file.managed:
    - source: salt://elastic/kibana/config/kibana.yml
    - user: root
    - group: root
    - mode: 744
    - makedirs: True
    
    
kibana_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/kibana_consul.json
    - source: salt://elastic/kibana/config/kibana_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 

start_kibana:
  service.running:
    - name: kibana