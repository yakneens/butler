resource "aws_instance" "butler_jump" {
	ami = "${lookup(var.aws_amis, var.region)}"
	instance_type = "t2.micro"
  
	tags {
		Name = "butler-jump"
	}
  
	vpc_security_group_ids = ["${aws_security_group.butler_external.id}"]
	subnet_id = "${aws_subnet.butler.id}"

	connection {
		user = "${var.username}"
	}
  
	key_name = "${aws_key_pair.butler_auth.id}"
  
	associate_public_ip_address = true
}

output "butler_jump_ip" {
	value = "${aws_instance.butler_jump.public_ip}"
}
