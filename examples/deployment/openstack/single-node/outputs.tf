output "butler" {
  value = "${openstack_compute_instance_v2.butler.access_ip_v4}"
}
