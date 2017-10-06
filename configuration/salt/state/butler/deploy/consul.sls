set_up_consul_servers:
  salt.state:
    - tgt: 'roles:consul-server'
    - tgt_type: grain
    - sls:
      - consul
      
set_up_consul_clients:
  salt.state:
    - tgt: 'roles:consul-client'
    - tgt_type: grain
    - sls:
      - consul
      
join_consul_members:
  salt.state:
    - tgt: 'salt-master'
    - sls:
      - consul.join-all

