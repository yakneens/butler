/etc/opt/consul.d/client-config.json:
  file.managed:
    - source: salt://consul/config/client/client-config.json
    - user: root
    - group: root
    - mode: 644
    
/usr/lib/systemd/system/consul-client.service:
  file.managed:
    - source: salt://consul/config/client/consul-client.service
    - user: root
    - group: root
    - mode: 744
    
consul-client:
  service.running:
    - enable: True
    - watch:
      - file: /etc/opt/consul.d/*    
