output "butler_jump_ip" {
	value = "${aws_instance.butler_jump.public_ip}"
}

output "salt-master" {
  value = "${aws_instance.salt-master.private_ip}"
}

output "db-server" {
 value = "${aws_instance.db-server.private_ip}"
}
output "tracker" {
 value = "${aws_instance.tracker.private_ip}"
}
output "job-queue" {
 value = "${aws_instance.job-queue.private_ip}"
}
output "worker-0" {
 value = "${aws_instance.worker.0.private_ip}"
}
output "worker-1" {
 value = "${aws_instance.worker.1.private_ip}"
}
output "worker-2" {
 value = "${aws_instance.worker.1.private_ip}"
}