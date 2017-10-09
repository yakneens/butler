resource "aws_instance" "tracker" {

    depends_on = ["aws_instance.salt-master"]

  	ami = "${lookup(var.aws_amis, var.region)}"
	instance_type = "${var.tracker-flavor}"
	associate_public_ip_address = true  
	tags {
		Name = "tracker"
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
	  source = "salt_setup.sh"
	  destination = "/tmp/salt_setup.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/salt_setup.sh",
	    "/tmp/salt_setup.sh ${null_resource.masterip.triggers.address} tracker \"tracker, consul-server\""
	  ]
	}
}

