elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Logstash YUM Repo
    - baseurl: http://packages.elasticsearch.org/elasticsearch/2.x/centos
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch

install_elasticsearch:
  pkg.installed:
    - name: elasticsearch
