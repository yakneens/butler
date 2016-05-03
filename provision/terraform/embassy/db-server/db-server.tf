provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}


resource "openstack_compute_instance_v2" "db-server" {
  	image_id = "${var.image_id}"
	flavor_name = "s1.huge"
	security_groups = ["internal"]
	name = "db-server"
	network = {
		uuid = "${var.network_id}"
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
			"echo 'id: db-server' | sudo tee -a /etc/salt/minion",
			"echo 'roles: [db-server, consul-client]' | sudo tee -a /etc/salt/grains",
			"sudo hostname db-server",
			"sudo service salt-minion start"
		]
	}
}

