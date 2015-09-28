glusterfs_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/glusterfs_consul.json
    - source: salt://glusterfs/config/glusterfs_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True

/etc/yum.repos.d/glusterfs-epel.repo:
  file.managed:
    - source: salt://glusterfs/config/glusterfs-epel.repo
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


/mnt/gluster/brick1:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True
   

