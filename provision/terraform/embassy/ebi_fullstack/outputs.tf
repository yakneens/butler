output "salt-master" {
  value = "${openstack_compute_floatingip_v2.floatingip.address}"
}

output "db-server" {
 value = "${openstack_compute_instance_v2.db-server.access_ip_v4}"
}
output "tracker" {
 value = "${openstack_compute_instance_v2.tracker.access_ip_v4}"
}
output "job-queue" {
 value = "${openstack_compute_instance_v2.job-queue.access_ip_v4}"
}
output "worker-0" {
 value = "${openstack_compute_instance_v2.worker.0.access_ip_v4}"
}
output "worker-1" {
 value = "${openstack_compute_instance_v2.worker.1.access_ip_v4}"
}
