include:
  - rabbitmq
  
enable_rabbitmq_on_startup:
  cmd.run:
    - name: chkconfig rabbitmq-server on

rabbitmq_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/rabbitmq_consul.json
    - source: salt://rabbitmq/conf/rabbitmq_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True  