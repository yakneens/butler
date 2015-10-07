dnsmasq:
  pkg.installed: []
  file.managed:
    - name: /etc/dnsmasq.conf
    - source: salt://dnsmasq/config/dnsmasq.conf
    - user: root
    - group: root
    - mode: 644
  file.append:
    - name: /etc/dnsmasq.d/10-consul
    - text: "server=/consul/127.0.0.1#8600"
    - makedirs: True
  service.running:
    - watch:
      - files:      
        - /etc/dnsmasq.conf
        - /etc/dnsmasq.d/*
