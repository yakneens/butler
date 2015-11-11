/usr/lib/systemd/system/airflow-worker.service:
  file.managed:
    - source: salt://airflow/config/airflow-worker.service
    - user: root
    - group: root
    - mode: 744

airflow-worker:
  service.running:
    - enable: True
