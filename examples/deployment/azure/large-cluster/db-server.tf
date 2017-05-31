resource "azurerm_network_interface" "db_server_nic" {
    name = "db_server_nic"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"

    ip_configuration {
        name = "db_server"
        subnet_id = "${azurerm_subnet.butler_subnet.id}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_virtual_machine" "db_server" {
	depends_on = ["azurerm_virtual_machine.salt_master"]
    name = "db-server"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    network_interface_ids = ["${azurerm_network_interface.db_server_nic.id}"]
    vm_size = "Standard_GS2"
    delete_os_disk_on_termination = true

    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "db_server_disk"
        vhd_uri = "${azurerm_storage_account.butler_storage.primary_blob_endpoint}${azurerm_storage_container.butler_storage_container.name}/db_server_disk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "db-server"
        admin_username = "${var.username}"
        admin_password = "Butler!"
    }

    os_profile_linux_config {
        disable_password_authentication = true
		ssh_keys {
			path = "${var.key_path}"
			key_data = "${file(var.public_key_path)}"
		}
    }

    tags {
        environment = "dev"
    }
    
    connection {
	  type     = "ssh"
	  user     = "${var.username}"
	  private_key = "${file(var.private_key_path)}"
	  bastion_private_key = "${file(var.private_key_path)}"
	  bastion_host = "${azurerm_public_ip.jump_ip.ip_address}"
	  bastion_user = "${var.username}"
	  host = "${azurerm_network_interface.db_server_nic.private_ip_address}"
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
	
    provisioner "file" {
	  source = "salt_setup.sh"
	  destination = "/tmp/salt_setup.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/salt_setup.sh",
	    "/tmp/salt_setup.sh ${null_resource.masterip.triggers.address} db-server \"db-server, consul-client\""
	  ]
	}
}
