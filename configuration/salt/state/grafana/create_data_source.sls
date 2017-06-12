create_data_source:
  cmd.run:
    - name: curl --user {{ pillar['grafana.user'] }}:{{ pillar['grafana.password'] }} '{{ pillar['grafana.api_url'] }}/datasources' -X POST --data-binary '{"name":"{{ pillar['influxdb.dbname'] }}","type":"influxdb","Url":"{{ pillar['influxdb.url'] }}","Access":"proxy","isDefault":true,"Database":"{{ pillar['influxdb.dbname'] }}","User":"{{ pillar['influxdb.user'] }}","Password":"{{ pillar['influxdb.password'] }}"}' -H Content-Type:application/json --noproxy {{ pillar['grafana.host'] }}
    