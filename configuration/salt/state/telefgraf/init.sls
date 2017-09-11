telegraf:
  pkg.installed:
    - sources:
      - telegraf: https://dl.influxdata.com/telegraf/releases/telegraf-1.4.0-1.x86_64.rpm
  service.running:
    - require:
      - pkg: telegraf