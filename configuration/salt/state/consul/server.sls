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
{%- set servers = salt['mine.get']('roles:(consul-server|consul-bootstrap)', 'network.ip_addrs', 'grain_pcre').values() %}
{%- set node_ip = salt['grains.get']('ip4_interfaces')['eth0'] %}
join-cluster:
{%- for server in servers if server[0] != node_ip %}
  module.run:
    - name: consul.agent_join
    - consul_url: http://127.0.0.1:8500
    - address: {{ server }}
    - watch:
      - service: consul-client   
{%- endfor %}  