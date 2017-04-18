resource "openstack_compute_floatingip_v2" "floatingip" {
  pool = "${var.floatingip_pool}"
}

resource "openstack_compute_secgroup_v2" "allow-traffic" {
  name        = "butler-firewall"
  description = "Allow traffic across butler instances"

  rule {
    ip_protocol = "icmp"
    from_port   = -1
    to_port     = -1
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = 22
    to_port     = 22
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = 1
    to_port     = 65535
    self        = "True"
  }

  rule {
    ip_protocol = "tcp"
    from_port   = 3000 
    to_port     = 3000
    cidr        = "0.0.0.0/0"
  }

}
