grafana.port: 3000
grafana.host: grafana.service.consul
grafana.api_url: 'http://{{ pillar['grafana.host'] }}:{{ pillar['grafana.port'] }}/api
grafana.db_name: grafana
grafana.user: admin
grafana.password: admin
grafana.dashboards: /var/lib/grafana/dashboards
