create_data_source:
  cmd.run:
    - name: curl --user admin:admin 'http://grafana.service.consul:3000/api/datasources' -X POST --data-binary '{"name":"metrics","type":"influxdb","Url":"http://influxdb.service.consul:8086","Access":"proxy","isDefault":true,"Database":"metrics","User":"root","Password":"root"}' -H Content-Type:application/json --noproxy grafana.service.consul
    