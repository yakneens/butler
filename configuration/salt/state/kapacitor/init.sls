kapacitor:
  pkg.installed:
    - sources:
      - influxdb: https://dl.influxdata.com/kapacitor/releases/kapacitor-1.3.1.x86_64.rpm
  service.running:
    - require:
      - pkg: kapacitor