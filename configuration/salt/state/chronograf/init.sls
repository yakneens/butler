chronograf:
  pkg.installed:
    - sources:
      - chronograf: https://dl.influxdata.com/chronograf/releases/chronograf-1.3.5.0.x86_64.rpm
  service.running:
    - require:
      - pkg: chronograf