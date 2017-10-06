set_up_consul:
  salt.state:
    - tgt: '*'
    - sls:
      - consul
      
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
     
