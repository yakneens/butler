consul_ui_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/consul_ui_consul.json
    - source: salt://consul/server/config/consul_ui_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
