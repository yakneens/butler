provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}


resource "openstack_compute_instance_v2" "chunker" {
  	image_id = "${var.image_id}"
	flavor_name = "m1.medium"
	security_groups = ["internal"]
	name = "chunker"
	connection {
		user = "${var.user}"
	 	key_file = "${var.key_file}"
	 	bastion_key_file = "${var.bastion_key_file}"
	 	bastion_host = "${var.bastion_host}"
	 	bastion_user = "${var.bastion_user}"
	 	agent = "true"
	 	
	}
	key_pair = "${var.key_pair}"
	provisioner "remote-exec" {
		inline = [
			"sudo yum install epel-release -y",
		    "sudo yum -y update",
		    "sudo yum install yum-plugin-priorities -y", 
			"sudo yum install salt-minion -y",
			"sudo service salt-minion stop",
			"echo 'master: ${var.salt_master_ip}' | sudo tee  -a /etc/salt/minion",
			"echo 'id: chunker' | sudo tee -a /etc/salt/minion",
			"echo 'roles: [chunker, consul-server]' | sudo tee -a /etc/salt/grains",
			"hostname chunker",
			"sudo service salt-minion start"
		]
	}
}

