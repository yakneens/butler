
/usr/lib/systemd/system/airflow-webserver.service:
  file.managed:
    - source: salt://airflow/config/airflow-webserver.service
    - user: root
    - group: root
    - mode: 744

airflow-webserver:
  service.running:
    - enable: True

/usr/lib/systemd/system/airflow-scheduler.service:
  file.managed:
    - source: salt://airflow/config/airflow-scheduler.service
    - user: root
    - group: root
    - mode: 744

airflow-scheduler:
  service.running:
    - enable: True
      
/usr/lib/systemd/system/airflow-flower.service:
  file.managed:
    - source: salt://airflow/config/airflow-flower.service
    - user: root
    - group: root
    - mode: 744
    - template: jinja
    
{{ pillar['airflow_flower_config'] }}:
  file.managed:
    - source: salt://airflow/config/flower_config.py
    - user: airflow
    - group: airflow
    - mode: 600
    - makedirs: True
    - template: jinja

airflow-flower:
  service.running:
    - enable: True
    
airflow_consul_config:
  file.managed:
    - name: /etc/opt/consul.d/airflow_consul.json
    - source: salt://airflow/config/airflow_consul.json
    - user: root
    - group: root
    - mode: 644 
    - makedirs: True 
  cmd.run:
    - name: systemctl restart consul

