dnsmasq:
  pkg.installed: []
  file.append:
    - name: /etc/dnsmasq.d/10-consul
    - text: "server=/consul/127.0.0.1#8600"
    - makedirs: True
  service.running:
    - watch:
      - file: /etc/dnsmasq.d/*
