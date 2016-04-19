unzip:
  pkg.installed: []

agent:
  archive.extracted:
    - name: /opt/consul/agent
    - source: https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_linux_amd64.zip
    - source_hash: md5=37000419d608fd34f0f2d97806cf7399
    - archive_format: zip
ui:
  archive.extracted:
    - name: /opt/consul/ui
    - source: https://releases.hashicorp.com/consul/0.5.2/consul_0.5.2_web_ui.zip
    - source_hash: md5=eb98ba602bc7e177333eb2e520881f4f
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
 
