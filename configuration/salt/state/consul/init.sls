unzip:
  pkg.installed: []

agent:
  archive.extracted:
    - name: /opt/consul/agent
    - source: https://releases.hashicorp.com/consul/0.9.3/consul_0.9.3_linux_amd64.zip
    - source_hash: sha256=9c6d652d772478d9ff44b6decdd87d980ae7e6f0167ad0f7bd408de32482f632
    - archive_format: zip
    - enforce_toplevel: False


/opt/consul/agent/consul:
  file.managed:
    - user: root
    - group: root
    - mode: 744
    - create: False

/usr/bin/consul:
  file.symlink:
    - target: /opt/consul/agent/consul
    - user: root
    - group: root
    - mode: 744
    - require:
      - file: /opt/consul/agent/consul

/var/consul:
  file.directory:
    - user: root
    - group: root
    - mode: 744
    - makedirs: True

/etc/opt/consul.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/opt/consul.d/:
  file.recurse:
    - source: salt://consul/config/host-level-checks
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644

{% set roles = salt['grains.get']('roles', '') %}

{% if "consul-server" in roles -%}
/etc/opt/consul.d/server-config.json:
  file.managed:
    - source: salt://consul/config/server-config.json
    - user: root
    - group: root
    - mode: 644
{% endif -%}

{% if "consul-client" in roles -%}
/etc/opt/consul.d/client-config.json:
  file.managed:
    - source: salt://consul/config/client-config.json
    - user: root
    - group: root
    - mode: 644
{% endif -%} 

/usr/lib/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/config/consul.service
    - user: root
    - group: root
    - mode: 744
    
consul:
  service.running:
    - enable: True
    - watch:
      - file: /etc/opt/consul.d/*
