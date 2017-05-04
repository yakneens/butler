install_erlang:
  pkg.installed:
    - name: erlang
    
install_rabbitmq:
  pkg.installed: 
    - sources: 
      - rabbitmq: https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.9/rabbitmq-server-3.6.9-1.el7.noarch.rpm

enable_rabbitmq_on_startup:
  cmd.run:
    - name: chkconfig rabbitmq-server on
    
    
start_rabbitmq:    
  service.running:
    - name: rabbitmq-server
    
rabbitmq_vhost:
  rabbitmq_vhost.present:
    - name: pcawg_vhost

    
rabbitmq_user:
  rabbitmq_user.present:
    - name: pcawg
    - password: pcawg
    - tags: 
      - management
    - perms:
      - 'pcawg_vhost':
        - '.*'
        - '.*'
        - '.*'
          
rabbitmq_management_plugin:
  rabbitmq_plugin.enabled:
    - name: rabbitmq_management
            
rabbitmq_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/rabbitmq_consul.json
    - source: salt://rabbitmq/conf/rabbitmq_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True  