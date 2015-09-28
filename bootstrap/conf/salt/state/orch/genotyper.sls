gluster_setup:
  salt.state:
    - tgt: 'roles:glusterfs-server'
    - tgt_type: grain
    - highstate: True
gluster_volume_setup:
  salt.state:
    - tgt: 'roles:glusterfs-master'
    - tgt_type: grain
    - sls: 
      - glusterfs.master
gluster_volume_mount:
  salt.state:
    - tgt: 'roles:glusterfs-server'
    - tgt_type: grain
    - sls:
      - glusterfs.mount