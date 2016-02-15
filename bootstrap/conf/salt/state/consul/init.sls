unzip:
  pkg.installed: []

agent:
  archive.extracted:
    - name: /opt/consul/agent
    - source: https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip
    - source_hash: md5=a336895f0b2d9c4679524f0c9896e1ec
    - archive_format: zip
ui:
  archive.extracted:
    - name: /opt/consul/ui
    - source: https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_web_ui.zip
    - source_hash: md5=f2b17fd7d9cf8dd00c4ab3aa674d33ca
    - archive_format: zip

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
 
