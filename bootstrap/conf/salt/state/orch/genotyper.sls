gluster_setup:
  salt.state:
    - tgt: roles:glusterfs-server
    - match: grain
    - highstate: True
gluster_volume_setup:
  salt.state:
    - tgt: roles:glusterfs-master
    - match: grain
    - sls: 
      - gluster.master
gluster_volume_mount:
  salt.state:
    - tgt: roles:glusterfs-server
    - match: grain
    - sls:
      - gluster.mount