influxdb.rpc_port: 8088
influxdb.admin_port: 8083
influxdb.http_port: 8086
influxdb.udp_port: 8096
influxdb.host: influxdb.service.consul
influxdb.url: http://{{ pillar.get('influxdb.host') }}:{{ pillar.get('influxdb.port') }}
influxdb.dbname: metrics
influxdb.user: root
influxdb.password: root
