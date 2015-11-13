logstash_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/elasticsearch_consul.json
    - source: salt://elastic/search/config/elasticsearch_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
    
elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Logstash YUM Repo
    - baseurl: http://packages.elasticsearch.org/elasticsearch/2.x/centos
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

install_elasticsearch:
  pkg.installed:
    - name: elasticsearch

enable_on_boot_elasticsearch:
  service.enabled:
    - name: elasticsearch

start_elasticsearch:    
  service.running:
    - name: elasticsearch