install_erlang:
  pkg.installed:
    - name: erlang
    
install_rabbitmq:
  pkg.installed: 
    - sources: 
      - rabbitmq: https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.6/rabbitmq-server-3.5.6-1.noarch.rpm

enable_on_startup:
  cmd.run:
    - name: chkconfig rabbitmq-server on
    
    
start_rabbitmq:    
  service.running:
    - name: rabbitmq-server
    - watch:
      - file: /etc/rabbitmq/*conf*
    
rabbitmq_user:
  rabbitmq_user.present:
    - name: pcawg
    - password: pcawg
    - perms:
      - 'pcawg_vhost':
        - '.*'
        - '.*'
        - '.*'  
        
rabbitmq_vhost:
  rabbitmq_vhost.present:
    - name: pcawg_vhost
    - user: pcawg
  