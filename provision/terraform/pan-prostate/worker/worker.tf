provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}

resource "openstack_compute_instance_v2" "worker" {
  	image_id = "${var.image_id}"
	flavor_name = "c1.germline-24core-96g"
	security_groups = ["internal"]
	name = "worker-${count.index}"
	network = {
		uuid = "${var.main_network_id}"
	}
	network = {
		uuid = "${var.gnos_network_id}"
	}
	connection {
		user = "${var.user}"
	 	private_key = "${file(var.key_file)}"
	 	bastion_private_key = "${file(var.bastion_key_file)}"
	 	bastion_host = "${var.bastion_host}"
	 	bastion_user = "${var.bastion_user}"
	 	agent = true
	 	
	}

	count = "39"
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
			"echo 'id: worker-${count.index}' | sudo tee -a /etc/salt/minion",
			"echo 'roles: [worker, germline, consul-client, R]' | sudo tee -a /etc/salt/grains",
			"sudo hostname worker-${count.index}",
			"sudo service salt-minion start"
		]
	}
}

