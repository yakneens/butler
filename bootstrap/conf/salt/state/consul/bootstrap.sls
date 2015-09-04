/etc/consul.d/bootstrap-config.json:
  file.managed:
    - source: salt://consul/config/bootstrap/bootstrap-config.json
    - user: root
    - group: root
    - mode: 644
    
/etc/init/consul-bootstrap.conf:
  file.managed:
    - source: salt://consul/config/bootstrap/bootstrap-upstart.conf
    - user: root
    - group: root
    - mode: 744
    
consul-bootstrap:
  service.running:
    - enable: True
    - watch:
      - file: /etc/consul.d/*
