resource "null_resource" "hostnames" {
	depends_on = ["openstack_compute_instance_v2.butler"]
	provisioner "remote-exec" {
		connection {
			host = "${var.bastion_host}"
	  		user = "${var.bastion_user}"
			type = "ssh"
			private_key = "${file(var.bastion_key_file)}"
		}
		inline = [
		  "echo '${openstack_compute_instance_v2.butler.access_ip_v4}\t butler\n' | sudo tee /etc/hosts"
		]
	
	}
}