resource "null_resource" "hostnames" {
	depends_on = ["aws_instance.salt-master",
						  "aws_instance.job-queue",
						  "aws_instance.db-server",
						  "aws_instance.tracker",
						  "aws_instance.worker",
						  ]
	provisioner "remote-exec" {
		
	
		connection {
			host = "${aws_instance.butler_jump.public_ip}"
	  		user = "${var.username}"
			type = "ssh"
			private_key = "${file(var.private_key_path)}"
		}
		
		inline = [
		  "echo '${aws_instance.salt-master.private_ip}\tsalt-master\n${aws_instance.tracker.private_ip}\ttracker\n${aws_instance.job-queue.private_ip}\tjob-queue\n${aws_instance.db-server.private_ip}\tdb-server\n127.0.0.1\tlocalhost\n' | sudo tee /etc/hosts"
		]
	
	}
}