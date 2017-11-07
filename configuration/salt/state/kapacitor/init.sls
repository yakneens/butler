kapacitor:
  pkg.installed:
    - sources:
      - kapacitor: https://dl.influxdata.com/kapacitor/releases/kapacitor-1.3.3.x86_64.rpm
  service.running:
    - require:
      - pkg: kapacitor
    - watch:
      - file: /etc/kapacitor/kapacitor.conf
      
/etc/kapacitor/kapacitor.conf:
  file.managed:
    - source: salt://kapacitor/config/kapacitor.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    
/bin/:
  file.recurse:
    - source: salt://kapacitor/config/scripts
    - user: kapacitor
    - group: kapacitor
    - dir_mode: 755
    - file_mode: 744