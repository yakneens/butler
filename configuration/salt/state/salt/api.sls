install_pyopenssl:
  pip.installed: 
    - name: pyopenssl
    - upgrade: True
    
install_cherrypy:
  pip.installed: 
    - name: cherrypy==4.0.0

    
salt-api:
  pkg.installed: []
  service.running: []

salt_api_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/salt_api_consul.json
    - source: salt://salt/config/salt_api_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True
  cmd.run:
    - name: systemctl restart consul