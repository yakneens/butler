resource "aws_instance" "butler_jump" {
	ami = "ami-fa2df395"
	instance_type = "t2.micro"
  
	tags {
		Name = "butler-jump"
	}
  
	vpc_security_group_ids = ["${aws_security_group.butler_external.id}"]
	subnet_id = "${aws_subnet.butler.id}"

	connection {
		user = "${var.username}"
		type = "ssh"
		private_key = "${file(var.private_key_path)}"
	}
  
	key_name = "${aws_key_pair.butler_auth.id}"
  
	associate_public_ip_address = true
	
	provisioner "file" {
	  source = "${var.private_key_path}"
	  destination = "${var.private_key_path}"
	}
	
	provisioner "remote-exec" {
	  inline = [
	    "echo 'Host *\n\tStrictHostKeyChecking no\n\tIdentityFile ${var.private_key_path}' >> ~/.ssh/config",
	    "chmod 600 ~/.ssh/*"
	  ]
	}
	
}

