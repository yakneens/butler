provider "openstack" {
	user_name = "${var.user_name}"
	password = "${var.password}"
	tenant_name = "${var.tenant_name}"
	auth_url = "${var.auth_url}"
}


resource "openstack_compute_instance_v2" "salt_master" {
  	image_id = "${var.image_id}"
	flavor_name = "m1.medium"
	security_groups = ["internal"]
	name = "salt-master"
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
			"sudo yum install salt-master -y",
			"sudo yum install salt-minion -y",
			"sudo yum install python-pip -y",
			"sudo yum install GitPython -y"
		]
	}
	provisioner "file" {
        	source = "./master"
        	destination = "/home/centos/master"
    	}
	provisioner "remote-exec" {
	›	inline = [
			"sudo service salt-master stop",
			"sudo service salt-minion stop",
			"sudo mv /home/centos/master /etc/salt/master",       
			"echo 'master: ${self.access_ip_v4}' | sudo tee -a /etc/salt/minion",
			"echo 'id: salt-master' | sudo tee -a /etc/salt/minion",
			"echo 'roles: [salt-master, consul-bootstrap, monitoring-server, glusterfs-master]' | sudo tee -a /etc/salt/grains",
			"sudo service salt-master start",
			"sudo hostname salt-master",
			"git clone https://github.com/llevar/germline-regenotyper",
			"git checkout develop",
			"ln -s /root/germline-regenotyper/bootstrap/conf/salt/state /srv/salt",
			"ln -s /root/germline-regenotyper/bootstrap/conf/salt/pillar /srv/pillar",
			"sudo service salt-minion start"
			    ]
        }
	provisioner "local-exec" {
		command = "export TF_VAR_salt_master_ip=${self.access_ip_v4}"
	}
}


