resource "aws_instance" "salt-master" {
	ami = "${lookup(var.aws_amis, var.region)}"
	instance_type = "${var.salt-master-flavor}"
	associate_public_ip_address = true  
	tags {
		Name = "salt-master"
	}
  
	vpc_security_group_ids = ["${aws_security_group.butler_internal.id}"]
	subnet_id = "${aws_subnet.butler.id}"

	key_name = "${aws_key_pair.butler_auth.id}"
  
	connection {
	  type     = "ssh"
	  user     = "${var.username}"
	  private_key = "${file(var.private_key_path)}"
	  bastion_private_key = "${file(var.private_key_path)}"
	  bastion_host = "${aws_instance.butler_jump.public_ip}"
	  bastion_user = "${var.username}"
	  host = "${self.private_ip}"
	}
    
    provisioner "file" {
    	source = "./master"
    	destination = "/home/${var.username}/master"
	}
	provisioner "file" {
    	source = "../../../../provision/base-image/collectd_log_allow.te"
    	destination = "/tmp/collectd_log_allow.te"
	}
	provisioner "file" {
	  source = "../../../../provision/base-image/install-packages.sh"
	  destination = "/tmp/install-packages.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/install-packages.sh",
	    "/tmp/install-packages.sh"
	  ]
	}
	provisioner "file" {
		source = "./collectdlocal.pp"
		destination = "/home/${var.username}/collectdlocal.pp"
	}
	provisioner "remote-exec" {
	  inline = [
		     "sudo yum install salt-master -y",
		     "sudo yum install salt-minion -y",
		     "sudo yum install python-pip -y",
		     "sudo pip uninstall tornado -y",
			 "sudo pip install tornado",
			 "sudo yum install GitPython -y",
		     "sudo service salt-master stop",
		     "sudo mv /home/${var.username}/master /etc/salt/master",       
		     "sudo service salt-master start",
		     "sudo hostname salt-master",
		     "sudo semodule -i collectdlocal.pp",
	  ]
	}
	provisioner "file" {
	  source = "salt_setup.sh"
	  destination = "/tmp/salt_setup.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/salt_setup.sh",
	    "/tmp/salt_setup.sh `sudo ifconfig eth0 | awk '/inet /{print $2}'` salt-master \"salt-master, consul-server, monitoring-server, consul-ui, butler-web\""
	  ]
	}
	
}

resource "null_resource" "masterip" {
  triggers = {
    address = "${aws_instance.salt-master.private_ip}"
  }
}