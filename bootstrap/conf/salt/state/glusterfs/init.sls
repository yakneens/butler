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