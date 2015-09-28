collectd_install:
  pkg.installed:
    - name: collectd

collectd_postgres_plugin_install:
  pkg.installed:
    - name: collectd-postgresql.x86_64
    
collectd_java_plugin_install:
  pkg.installed:
    - name: collectd-java.x86_64

collectd_jmx_plugin_install:
  pkg.installed:
    - name: collectd-generic-jmx.x86_64
    
collectd_sensu_plugin_install:
  pkg.installed:
    - name: collectd-write_sensu.x86_64    
    
collectd_run:
  service.running:
    - name: collectd 
    - require:
      - pkg: collectd
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
