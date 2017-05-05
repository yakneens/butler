set_up_consul_servers:
  salt.state:
    - tgt: 'roles:consul-server'
    - tgt_type: grain
    - sls:
      - consul
      - consul.server
      
set_up_consul_clients:
  salt.state:
    - tgt: 'roles:consul-client'
    - tgt_type: grain
    - sls:
      - consul
      - consul.client
      
join_consul_members:
  salt.state:
    - tgt: 'salt-master'
    - sls:
      - consul.join-all

set_up_salt_master:
  salt.state:
    - tgt: 'salt-master'
    - highstate: True

set_up_db_server:
   salt.state:
     - tgt: 'roles:db-server'
     - tgt_type: grain
     - highstate: True
 
set_up_job_queue:
   salt.state:
     - tgt: 'roles:job-queue'
     - tgt_type: grain
     - highstate: True

set_up_tracker:
   salt.state:
     - tgt: 'roles:tracker'
     - tgt_type: grain
     - highstate: True

set_up_monitoring_server:
   salt.state:
     - tgt: 'roles:monitoring-server'
     - tgt_type: grain
     - highstate: True
     
set_up_workers:
   salt.state:
     - tgt: 'roles:worker'
     - tgt_type: grain
     - highstate: True
     
set_up_grafana:
   salt.state:
     - tgt: 'roles:monitoring-server'
     - tgt_type: grain
     - sls: 
       - grafana.create_data_source
