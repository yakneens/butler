telegraf:
  pkg.installed:
    - sources:
      - telegraf: https://dl.influxdata.com/telegraf/releases/telegraf-1.5.2-1.x86_64.rpm
  service.running:
    - require:
      - pkg: telegraf
    - watch:
      - file: /etc/telegraf/telegraf.conf
            
/etc/telegraf/telegraf.conf:
  file.managed:
    - source: salt://telegraf/config/telegraf.conf
    - user: telegraf
    - group: telegraf
    - mode: 644
    - template: jinja