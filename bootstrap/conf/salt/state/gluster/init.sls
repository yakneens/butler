glusterfs_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/glusterfs_consul.json
    - source: salt://gluster/config/glusterfs_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True

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

   

