adduser:
  pkg.installed: []

libfontconfig:
  pkg.installed: []

grafana:
  pkg.installed:
    - sources:
      - grafana: https://grafanarel.s3.amazonaws.com/builds/grafana_2.1.2_amd64.deb
  service.running:
    - name: grafana-server
    - require:
      - pkg: grafana

