list_consul_members:
  salt.function:
    - tgt: 'salt-master'
    - name: cmd.run
    - arg:
      - consul members
      
test_postgres_service:
  salt.function:
    - tgt: 'db-server'
    - name: cmd.run
    - arg:
      - test $(service postgresql-9.5 status | grep running | wc -l) > 0 && /bin/true
      
test_postgres_service_name:
  salt.function:
    - tgt: 'db-server'
    - name: cmd.run
    - arg:
      - test $(getent hosts postgresql.service.consul | wc -l) > 0 && /bin/true

test_rabbitmq_service:
  salt.function:
    - tgt: 'job-queue'
    - name: cmd.run
    - arg:
      - test $(service rabbitmq-server status | grep running | wc -l) > 0 && /bin/true
      
test_rabbitmq_service_name:
  salt.function:
    - tgt: 'job-queue'
    - name: cmd.run
    - arg:
      - test $(getent hosts rabbitmq.service.consul | wc -l) > 0 && /bin/true