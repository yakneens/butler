/opt/kibana:
  archive.extracted:
    - source: https://artifacts.elastic.co/downloads/kibana/kibana-5.6.0-linux-x86_64.tar.gz
    - archive_format: tar
    - options: z
    - source_hash: sha1=741e45710e93f637b41adfb57efee7acce0f2b99

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
  cmd.run:
    - name: systemctl restart consul
    
start_kibana:
  service.running:
    - name: kibana