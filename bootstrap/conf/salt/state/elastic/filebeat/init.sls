install_filebeat:
  pkg.installed:
    - sources:
      - filebeat: https://download.elastic.co/beats/filebeat/filebeat-1.0.0-rc1-x86_64.rpm
      
/etc/filebeat/filebeat.yml:
  file.managed:
    - source: salt://elastic/filebeat/config/filebeat.yml
    - user: root
    - group: root
    - mode: 600
    - makedirs: True