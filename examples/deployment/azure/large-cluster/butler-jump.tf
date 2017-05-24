# create public IP
resource "azurerm_public_ip" "jump_ip" {
    name = "jump_ip"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Butler"
    }
}

resource "azurerm_network_interface" "jump_nic" {
    name = "jump_nic"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.butler_subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.jump_ip.id}"
    }
}

resource "azurerm_virtual_machine" "butler_jump" {
    name = "butler_jump"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    network_interface_ids = ["${azurerm_network_interface.jump_nic.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk"
        vhd_uri = "${azurerm_storage_account.butler_storage.primary_blob_endpoint}${azurerm_storage_container.butler_storage_container.name}/jump_disk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "butler-jump"
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
}