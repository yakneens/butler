/etc/opt/consul.d/bootstrap-config.json:
  file.managed:
    - source: salt://consul/config/bootstrap/bootstrap-config.json
    - user: root
    - group: root
    - mode: 644
    
/usr/lib/systemd/system/consul-bootstrap.service:
  file.managed:
    - source: salt://consul/config/bootstrap/consul-bootstrap.service
    - user: root
    - group: root
    - mode: 744
    
consul-bootstrap:
  service.running:
    - enable: True
    - watch:
      - file: /etc/opt/consul.d/*
