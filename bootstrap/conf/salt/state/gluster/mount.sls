{%- set gluster_master = salt['mine.get']('roles:glusterfs-master', 'network.get_hostname', 'grain_pcre').values() %}

/share:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True 
    
gluster_share_mount:
  mount.mounted:
    - name: /share
    - device: {{ gluster_master[0] }}:/share
    - fstype: glusterfs