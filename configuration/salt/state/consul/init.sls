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
 
