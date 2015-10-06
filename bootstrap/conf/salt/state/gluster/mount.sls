{%- set gluster_master = salt['mine.get']('roles:glusterfs-master', 'network.get_hostname', 'grain_pcre').values() %}

/shared:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True 
    
gluster_share_mount:
  mount.mounted:
    - name: /shared
    - device: {{ gluster_master[0] }}:/shared
    - fstype: glusterfs