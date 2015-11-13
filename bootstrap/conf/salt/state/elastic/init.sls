#logstash_repo:
#  pkgrepo.managed:
#    - humanname: Logstash YUM Repo
#    - baseurl: http://packages.elasticsearch.org/logstash/2.0/centos
#    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    
elastic_repo:
  pkgrepo.managed:
    - humanname: Elastic YUM Repo
    - baseurl: http://packages.elasticsearch.org
    - gpgkey: http://packages.elasticsearch.org/GPG-KEY-elasticsearch
    