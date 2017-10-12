install_erlang:
  pkg.installed:
    - name: erlang
    
install_rabbitmq:
  pkg.latest: 
    - name: rabbitmq-server
    
rabbitmq_management_plugin:
  rabbitmq_plugin.enabled:
    - name: rabbitmq_management
            
    
start_rabbitmq:    
  service.running:
    - name: rabbitmq-server
    - enable: True
    
rabbitmq_vhost:
  rabbitmq_vhost.present:
    - name: {{ pillar['rabbitmq.vhost'] }}

    
rabbitmq_user:
  rabbitmq_user.present:
    - name: {{ pillar['rabbitmq.user'] }}
    - password: {{ pillar['rabbitmq.password'] }}
    - tags: 
      - management
      - administrator
    - perms:
      - '{{ pillar['rabbitmq.vhost'] }}':
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
    - template: jinja
  cmd.run:
    - name: systemctl restart consul