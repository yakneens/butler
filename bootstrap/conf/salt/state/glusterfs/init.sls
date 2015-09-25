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

{%- set servers = salt['mine.get']('roles:glusterfs-server', 'network.ip_addrs', 'grain_pcre').values() %}
blah:
  cmd.run:
    - name: echo '{{servers}}'

cluster-peers:
  glusterfs.peered:
    - names:
{%- for server in servers %}
      - {{ server[0] }}
{%- endfor %}

cluster-volume:
  glusterfs.created:
    - name: share
    - bricks:
{%- for server in servers %}
      - {{ server[0] }}:/mnt
{%- endfor %}
    - stripe: {{ servers|length }}
    

cluster-start:
  glusterfs.started:
    - name: share  