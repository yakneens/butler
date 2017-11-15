resource "openstack_compute_instance_v2" "butler" {
  	image_id = "${var.image_id}"
	flavor_name = "${var.butler-flavor}"
	security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "${var.main-security-group-id}"]
	name = "butler"
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
	    "/tmp/salt_setup.sh `sudo ifconfig eth0 | awk '/inet /{print $2}'` butler \"salt-master, consul-server, db-server, job-queue, tracker, worker, monitoring-server, consul-ui, butler-web, elasticsearch\""
	  ]
	}
	provisioner "remote-exec" {
	  inline = [
		     "sudo yum install salt-master -y",
		     "sudo service salt-master stop",
		     "sudo mv -f /home/centos/master /etc/salt/master",       
		     "sudo yum install salt-minion -y",
		     "sudo yum install python-pip -y",
		     "sudo pip uninstall tornado",
		     "sudo pip install tornado",
		     "sudo yum install GitPython -y",
		     "sudo service salt-master start",
		     "sudo hostname salt-master",
		     "sudo semodule -i collectdlocal.pp",
	  ]
        }
}
