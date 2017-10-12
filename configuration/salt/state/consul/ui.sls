consul_ui_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/consul_ui_consul.json
    - source: salt://consul/config/consul_ui_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
  cmd.run:
    - name: systemctl restart consul