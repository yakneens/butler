provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}


resource "openstack_compute_instance_v2" "tracker" {
  	image_id = "${var.image_id}"
	flavor_name = "m1.medium"
	security_groups = ["internal"]
	name = "tracker"
	network = {
		uuid = "${var.main_network_id}"
	}
	network = {
		uuid = "${var.gnos_network_id}"
	}
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
		    "wget https://repo.saltstack.com/yum/rhel7/SALTSTACK-GPG-KEY.pub",
			"rpm --import SALTSTACK-GPG-KEY.pub",
			"rm -f SALTSTACK-GPG-KEY.pub"
		]
		
	}
	provisioner "file" {
			source = "../saltstack.repo"
			destination = "/home/centos/saltstack.repo"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo mv /home/centos/saltstack.repo /etc/yum.repos.d/saltstack.repo", 
			"sudo yum install salt-minion -y",
			"sudo service salt-minion stop",
			"echo 'master: ${var.salt_master_ip}' | sudo tee  -a /etc/salt/minion",
			"echo 'id: tracker' | sudo tee -a /etc/salt/minion",
			"echo 'roles: [tracker, consul-client]' | sudo tee -a /etc/salt/grains",
			"sudo hostname tracker",
			"sudo service salt-minion start"
		]
	}
}

