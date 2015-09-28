{%- set servers = salt['mine.get']('roles:glusterfs-server', 'network.get_hostname', 'grain_pcre').values() %}
blah:
  cmd.run:
    - name: echo '{{servers}}'

cluster-peers:
  glusterfs.peered:
    - names:
{%- for server in servers %}
      - {{ server }}
{%- endfor %}

cluster-volume:
  glusterfs.created:
    - name: share
    - bricks:
{%- for server in servers %}
      - {{ server }}:/mnt/gluster/brick1
{%- endfor %}
    - stripe: {{ servers|length }}
    - start: True
    - require:
      - glusterfs: cluster-peers
    
