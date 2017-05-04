
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

airflow-flower:
  service.running:
    - enable: True
