/tmp/collectd_log_allow.pp:
  file.managed:
    - source: salt://collectd/config/collectd_log_allow.pp
    - user: root
    - password: root
    - mode: 644

allow_collectd_log_write:
  cmd.run:
    - name: semodule -i /tmp/collectd_log_allow.pp

collectd_install:
  pkg.installed:
    - name: collectd

collectd_run:
  service.running:
    - name: collectd 
    - require:
      - pkg: collectd
      - cmd: allow_collectd_log_write
    - watch:
      - file: /etc/collectd.conf
      - file: /usr/share/collectd/types.db
      
      
collectd_config:
  file.managed:
    - name: /etc/collectd.conf
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
