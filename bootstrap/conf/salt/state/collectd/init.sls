collectd_install:
  pkg.installed:
    - name: collectd

collectd_run:
  service.running:
    - name: collectd 
    - require:
      - pkg: collectd
    - watch:
      - file: /etc/collectd/collectd.conf
      - file: /usr/share/collectd/types.db
      
      
collectd_config:
  file.managed:
    - name: /etc/collectd/collectd.conf
    - source: salt://collectd/config/collectd.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - pkg: collectd


collectd_types_db:
  file.managed:
    - name: /usr/share/collectd/types.db
    - source: salt://collectd/config/types.db
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - pkg: collectd    
