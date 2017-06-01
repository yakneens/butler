collectd_install:
  pkg.installed:
    - name: collectd

collectd_postgres_plugin_install:
  pkg.installed:
    - name: collectd-postgresql.x86_64
    
collectd_java_plugin_install:
  pkg.installed:
    - name: collectd-java.x86_64

/lib64/libjvm.so:
  file.symlink:
    - target: /usr/lib/jvm/jre/lib/amd64/server/libjvm.so

collectd_rrdtool_plugin_install:
  pkg.installed:
    - name: collectd-rrdtool.x86_64

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
      - file: {{ pillar['collectd.typesdb'] }}
      
      
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
    - template: jinja
      
collectd_log:
  file.managed:
    - name: /var/log/collectd.log
    - user: root
    - group: root
    - mode: 666



collectd_types_db:
  file.managed:
    - name: {{ pillar['collectd.typesdb'] }}
    - source: salt://collectd/config/types.db
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - pkg: collectd    
