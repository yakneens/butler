dnsmasq:
  pkg.installed: []
  service.running:
    - watch:
      - file: /etc/dnsmasq.conf
      - file: /etc/dnsmasq.d/*
        
/etc/dnsmasq.conf:
  file.managed:
    - source: salt://dnsmasq/config/dnsmasq.conf
    - user: root
    - group: root
    - mode: 644
    
/etc/dnsmasq.d/10-consul:    
  file.append:
    - text: "server=/consul/127.0.0.1#8600"
    - makedirs: True
    

/etc/resolv.conf:
  file.prepend:
    - header: True
    - text:
      - nameserver 127.0.0.1
      - nameserver 8.8.8.8

      
  