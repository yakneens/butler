resource "null_resource" "hostnames" {
	depends_on = ["openstack_compute_instance_v2.salt-master",
						  "openstack_compute_instance_v2.job-queue",
						  "openstack_compute_instance_v2.db-server",
						  "openstack_compute_instance_v2.tracker",
						  "openstack_compute_instance_v2.worker",
						  ]
	provisioner "remote-exec" {
		
	
		connection {
			host = "${var.bastion_host}"
	  		user = "${var.bastion_user}"
			type = "ssh"
			private_key = "${file(var.bastion_key_file)}"
		}
		
		inline = [
		  "echo '${openstack_compute_instance_v2.salt-master.access_ip_v4}\tsalt-master\n${openstack_compute_instance_v2.tracker.access_ip_v4}\ttracker\n${openstack_compute_instance_v2.job-queue.access_ip_v4}\tjob-queue\n${openstack_compute_instance_v2.db-server.access_ip_v4}\tdb-server\n' | sudo tee /etc/hosts"
		]
	
	}
}