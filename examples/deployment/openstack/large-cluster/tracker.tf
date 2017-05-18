resource "openstack_compute_instance_v2" "tracker" {

    depends_on = ["openstack_compute_instance_v2.salt-master"]

  	image_id = "${var.image_id}"
	flavor_name = "s1.massive"
	security_groups = ["${openstack_compute_secgroup_v2.allow-traffic.name}", "Pan-Prostate-Internal"]
	name = "butler-tracker"
	network = {
		uuid = "${var.main_network_id}"
	}
	network = {
		uuid = "${var.pan_prostate_network_id}"
	}
	network = {
		uuid = "${var.gnos_network_id}"
	}
	connection {
		user = "${var.user}"
	 	private_key = "${file(var.key_file)}"
	 	bastion_private_key = "${file(var.key_file)}"
	 	bastion_host = "${var.bastion_host}"
	 	bastion_user = "${var.bastion_user}"
	 	agent = true
	 	
	}
	key_pair = "${var.key_pair}"

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

