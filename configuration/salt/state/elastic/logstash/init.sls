logstash_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/logstash_consul.json
    - source: salt://elastic/logstash/config/logstash_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
  cmd.run:
    - name: systemctl restart consul
        
logstash_repo:
  pkgrepo.managed:
    - humanname: Logstash YUM Repo
    - baseurl: https://artifacts.elastic.co/packages/5.x/yum
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

install_logstash:
  pkg.installed:
    - name: logstash
    
enable_on_boot_logstash:
  service.enabled:
    - name: logstash

install_beats_plugin:
  cmd.run:
    - name: /usr/share/logstash/bin/logstash-plugin install logstash-input-beats
    
update_beats_plugin:
  cmd.run:
    - name: /usr/share/logstash/bin/logstash-plugin update logstash-input-beats
    
/etc/logstash/conf.d/config.json:
  file.managed:
    - source: salt://elastic/logstash/config/config.json
    - user: logstash
    - group: logstash
    - mode: 600
    - makedirs: True

start_logstash:    
  service.running:
    - name: logstash
    
    