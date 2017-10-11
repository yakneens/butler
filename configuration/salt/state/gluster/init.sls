glusterfs_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/glusterfs_consul.json
    - source: salt://gluster/config/glusterfs_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True
  cmd.run:
    - name: systemctl restart consul
    
/etc/yum.repos.d/glusterfs-epel.repo:
  file.managed:
    - source: salt://gluster/config/glusterfs-epel.repo
    - user: root
    - group: root
    - mode: 644
    
glusterfs-server:
  pkg.installed: []

glusterd:
  service.running:
    - enable: True
    - requre:
      - pkg: glusterfs-server

{%- set gluster_master = salt['mine.get']('roles:glusterfs-master', 'network.get_hostname', 'grain_pcre').values() %}

master-peers:
  glusterfs.peered:
    - names:
      - {{ gluster_master[0] }}

volume_voodoo:
  cmd.run:
    - name: setfattr -x trusted.gfid /mnt/gluster/brick1

volume_voodo2:
  cmd.run:
    - name: setfattr -x trusted.glusterfs.volume-id /mnt/gluster/brick1



   

