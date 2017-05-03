resource "openstack_compute_instance_v2" "salt-master" {
  	image_id = "${var.image_id}"
	flavor_name = "s1.massive"
	security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "Pan-Prostate-Internal"]
	name = "butler-salt-master"
	network = {
		uuid = "${var.main_network_id}"
	}
	connection {
		user = "${var.user}"
	 	private_key = "${file(var.key_file)}"
	 	agent = true
	 	bastion_private_key = "${file(var.bastion_key_file)}"
	 	bastion_host = "${var.bastion_host}"
	 	bastion_user = "${var.bastion_user}"
	 	
	}
	key_pair = "${var.key_pair}"
  	
	 	
	provisioner "file" {
        	source = "./master"
        	destination = "/home/centos/master"
    	}
	provisioner "file" {
        	source = "./collectdlocal.pp"
        	destination = "/home/centos/collectdlocal.pp"
    	}
	provisioner "file" {
	  source = "salt_setup.sh"
	  destination = "/tmp/salt_setup.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/salt_setup.sh",
	    "/tmp/salt_setup.sh `sudo ifconfig eth0 | awk '/inet /{print $2}'` salt-master \"salt-master, consul-server, monitoring-server\""
	  ]
	}
	provisioner "remote-exec" {
	  inline = [
		     "sudo yum install salt-master -y",
		     "sudo yum install salt-minion -y",
		     "sudo yum install python-pip -y",
		     "sudo yum install GitPython -y",
		     "sudo service salt-master stop",
		     "sudo mv /home/centos/master /etc/salt/master",       
		     "sudo service salt-master start",
		     "sudo hostname salt-master",
		     "sudo semodule -i collectdlocal.pp",
	  ]
        }
}
