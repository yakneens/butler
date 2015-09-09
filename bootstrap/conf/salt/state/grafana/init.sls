initscripts:
  pkg.installed: []

fontconfig:
  pkg.installed: []

grafana:
  pkg.installed:
    - sources:
      - grafana: https://grafanarel.s3.amazonaws.com/builds/grafana-2.1.3-1.x86_64.rpm
  service.running:
    - name: grafana-server
    - require:
      - pkg: grafana

