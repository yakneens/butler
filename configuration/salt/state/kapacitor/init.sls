kapacitor:
  pkg.installed:
    - sources:
      - kapacitor: https://dl.influxdata.com/kapacitor/releases/kapacitor-1.4.0.x86_64.rpm
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
    - source: salt://kapacitor/scripts/
    - user: kapacitor
    - group: kapacitor
    - dir_mode: 755
    - file_mode: 744
    
/tmp/kapacitor_ticks/:
  file.recurse:
    - source: salt://kapacitor/scripts
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    