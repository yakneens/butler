grafana.port: 3000
grafana.host: grafana.service.consul
grafana.api_url: http://{{ pillar.get('grafana.host') }}:{{ pillar.get('grafana.port') }}/api
grafana.db_name: grafana
grafana.user: admin
grafana.password: admin
grafana.dashboards: /var/lib/grafana/dashboards
