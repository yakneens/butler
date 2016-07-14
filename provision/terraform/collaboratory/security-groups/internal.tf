provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}

resource "openstack_compute_secgroup_v2" "internal" {
	name = "internal"
	description = "Allows communication between instances"
	rule {
		from_port = -1
		to_port = -1
		ip_protocol = "icmp"
		self = "true"
	}
	#SSH
	rule {
		from_port = 22
		to_port = 22
		ip_protocol = "tcp"
		self = "true"
	}
	#Saltstack
	rule {
		from_port = 4505
		to_port = 4506
		ip_protocol = "tcp"
		self = "true"
	}
	#Proxy
	rule {
		from_port = 8080
		to_port = 8080
		ip_protocol = "tcp"
		self = "true"
	}
	#???
	rule {
		from_port = 53
		to_port = 53
		ip_protocol = "udp"
		self = "true"
	}
	#Consul
	rule {
		from_port = 8300
		to_port = 8300
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8400
		to_port = 8400
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8500
		to_port = 8500
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8301
		to_port = 8302
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8301
		to_port = 8302
		ip_protocol = "udp"
		self = "true"
	}
	rule {
		from_port = 8600
		to_port = 8600
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8600
		to_port = 8600
		ip_protocol = "udp"
		self = "true"
	}
	#InfluxDB
	rule {
		from_port = 8083
		to_port = 8083
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8086
		to_port = 8086
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8096
		to_port = 8096
		ip_protocol = "udp"
		self = "true"
	}
	#Collectd
	rule {
		from_port = 25826
		to_port = 25826
		ip_protocol = "udp"
		self = "true"
	}
	#Grafana
	rule {
		from_port = 3000
		to_port = 3000
		ip_protocol = "tcp"
		self = "true"
	}
	#Postgres
	rule {
		from_port = 5432
		to_port = 5432
		ip_protocol = "tcp"
		self = "true"
	}
	#Glusterfs
	rule {
		from_port = 24007
		to_port = 24008
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 49152
		to_port = 49202
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 38465
		to_port = 38467
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 111
		to_port = 111
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 111
		to_port = 111
		ip_protocol = "udp"
		self = "true"
	}
	rule {
		from_port = 2049
		to_port = 2049
		ip_protocol = "tcp"
		self = "true"
	}
	#RabbitMQ
	rule {
		from_port = 4369
		to_port = 4369
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 25672
		to_port = 25672
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 5671
		to_port = 5672
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 15672
		to_port = 15672
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 61613
		to_port = 61614
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 1883
		to_port = 1883
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 8883
		to_port = 8883
		ip_protocol = "tcp"
		self = "true"
	}
	#Celery
	rule {
		from_port = 5555
		to_port = 5555
		ip_protocol = "tcp"
		self = "true"
	}
	#Statsd
	rule {
		from_port = 8125
		to_port = 8125
		ip_protocol = "tcp"
		self = "true"
	}
	#Elasticsearch
	rule {
		from_port = 9200
		to_port = 9200
		ip_protocol = "tcp"
		self = "true"
	}
	rule {
		from_port = 9300
		to_port = 9300
		ip_protocol = "tcp"
		self = "true"
	}
	#Logstash
	rule {
		from_port = 5044
		to_port = 5044
		ip_protocol = "tcp"
		self = "true"
	}
	#Kibana
	rule {
		from_port = 5601
		to_port = 5601
		ip_protocol = "tcp"
		self = "true"
	}
	#Airflow
	rule {
		from_port = 8793
		to_port = 8793
		ip_protocol = "tcp"
		self = "true"
	}
	
	
}