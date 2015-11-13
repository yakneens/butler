logstash_repo:
  pkgrepo.managed:
    - humanname: Logstash YUM Repo
    - baseurl: http://packages.elasticsearch.org/logstash/2.0/centos
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

install_logstash:
  pkg.installed:
    - name: logstash
    
enable_on_boot_logstash:
  service.enabled:
    - name: logstash

start_logstash:    
  service.running:
    - name: logstash