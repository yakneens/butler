unzip:
  pkg.installed: []

agent:
  archive.extracted:
    - name: /opt/consul/agent
    - source: https://releases.hashicorp.com/consul/1.0.7/consul_1.0.7_linux_amd64.zip
    - source_hash: 6c2c8f6f5f91dcff845f1b2ce8a29bd230c11397c448ce85aae6dacd68aa4c14
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
    
/var/run/consul:
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

/etc/opt/consul.d/consul-config.json:
  file.managed:
    - source: salt://consul/config/consul-config.json
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/usr/lib/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/config/consul.service
    - user: root
    - group: root
    - mode: 644

    
consul:
  service.running:
    - enable: True
    - watch:
      - file: /etc/opt/consul.d/*
