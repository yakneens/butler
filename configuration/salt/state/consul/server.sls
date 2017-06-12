/etc/opt/consul.d/server-config.json:
  file.managed:
    - source: salt://consul/config/server/server-config.json
    - user: root
    - group: root
    - mode: 644
    
/usr/lib/systemd/system/consul-server.service:
  file.managed:
    - source: salt://consul/config/server/consul-server.service
    - user: root
    - group: root
    - mode: 744
    
consul-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/opt/consul.d/*

