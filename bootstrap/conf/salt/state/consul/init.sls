agent:
  archive.extracted:
    - name: /etc/consul/agent
    - source: https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip
    - source_hash: md5=37000419d608fd34f0f2d97806cf7399
    - archive_format: zip
ui:
  archive.extracted:
    - name: /etc/consul/ui
    - source: https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip
    - source_hash: md5=eb98ba602bc7e177333eb2e520881f4f
    - archive_format: zip

/etc/consul/agent/consul:
  file.managed:
    - user: root
    - group: root
    - mode: 744

/usr/local/bin/consul:
  file.symlink:
    - target: /etc/consul/agent/consul
    - user: root
    - group: root
    - mode: 744

/var/consul:
  file.directory:
    - user: root
    - group: root
    - mode: 744
    - makedirs: True

/etc/consul.d:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/init:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
   

/etc/consul.d/:
  file.recurse:
    - source: salt://consul/config/host-level-checks
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
 
