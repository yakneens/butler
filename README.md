# germline-regenotyper
- Clone the repo
- Install gradle or run ./gradlew from any submodule
- Run ```gradle eclipse``` to generate eclipse project files
- Import project files into Eclipse


# Ports Configuration
The following ports need to be open for various components to work properly
Salstack - TCP ports 4505-4506 on the Salt Master
Consul - TCP ports only - 8300, 8400, 8500. TCP and UDP - 8301, 8302, 8600
Influxdb - TCP port 8083, 8086
Collectd - UDP port 25826
Grafana - HTTP port 3000

