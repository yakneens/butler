install_erlang:
  pkg.installed:
    - name: erlang
    
install_rabbitmq:
  pkg.installed: 
    - sources: 
      - rabbitmq: https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.9/rabbitmq-server-3.6.9-1.el7.noarch.rpm
    
rabbitmq_management_plugin:
  rabbitmq_plugin.enabled:
    - name: rabbitmq_management
            
    
start_rabbitmq:    
  service.running:
    - name: rabbitmq-server
    - enable: True
    
rabbitmq_vhost:
  rabbitmq_vhost.present:
    - name: pcawg_vhost

    
rabbitmq_user:
  rabbitmq_user.present:
    - name: pcawg
    - password: pcawg
    - tags: 
      - management
      - administrator
    - perms:
      - 'pcawg_vhost':
        - '.*'
        - '.*'
        - '.*'
          
rabbitmq_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/rabbitmq_consul.json
    - source: salt://rabbitmq/conf/rabbitmq_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True  