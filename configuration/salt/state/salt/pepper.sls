install_salt_peppe:
  pip.installed: 
    - name: salt-pepper
    - upgrade: True
    
/root/.pepperrc:
  file.managed:
    - source: salt://salt/config/pepperrc
    - user: root
    - group: root
    - mode: 644
   
/var/lib/kapacitor/.pepperrc:
  file.managed:
    - source: salt://salt/config/pepperrc
    - user: kapacitor
    - group: kapacitor
    - mode: 644