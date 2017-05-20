# create public IP
resource "azurerm_public_ip" "salt_master_ip" {
    name = "butler_test_ip"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    public_ip_address_allocation = "dynamic"

    tags {
        environment = "Butler"
    }
}

resource "azurerm_network_interface" "salt_master_nic" {
    name = "salt_master_nic"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.butler_subnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.salt_master_ip.id}"
    }
}

resource "azurerm_virtual_machine" "salt_master" {
    name = "salt_master"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    network_interface_ids = ["${azurerm_network_interface.salt_master_nic.id}"]
    vm_size = "Standard_A0"

    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "myosdisk"
        vhd_uri = "${azurerm_storage_account.butler_storage.primary_blob_endpoint}${azurerm_storage_container.butler_storage_container.name}/myosdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "salt-master"
        admin_username = "butler"
        admin_password = "Butler!"
    }

    os_profile_linux_config {
        disable_password_authentication = true
		ssh_keys {
			path = "/home/butler/.ssh/authorized_keys"
			key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5Wmj5zKTk09u+tLO7/7iRs2VhclKaHFdRfxbqC2nm+htceU+AHa0ePLgmhuXv3aZscBwsSjFf/H0KGPccB6VROhL7wZmQJe5dWfOJvWSZGK5WkLcpO7PGE16hOuU88WCkwRWO/g02uBweYqTzQXCsS29T7qxm5SK9Xgx9YwuG2+u0gZG8cF+gQtjoxOA7uVREstYl27XrHXOS1s8QZ1cRs8MEHwV7ORJpZdXcz8we9d0nQAYUBJWCNhK34quU3jZDtebc1F27zyM3K0YlNxURJLCLpf7KdpyaSzBDYaugEnNdNPB3/wwdU6d8p+Oweuzsw2ESvnGVr7J4iKQlN45b siakhnin@olm-siakhnin.local"
		}
    }

    tags {
        environment = "dev"
    }
    
    provisioner "file" {
    	source = "./master"
    	destination = "/home/butler/master"
	}
	provisioner "file" {
    	source = "./collectdlocal.pp"
    	destination = "/home/butler/collectdlocal.pp"
	}
	provisioner "file" {
	  source = "salt_setup.sh"
	  destination = "/tmp/salt_setup.sh"
	}
	provisioner "remote-exec" {
	  inline = [
	    "chmod +x /tmp/salt_setup.sh",
	    "/tmp/salt_setup.sh `sudo ifconfig eth0 | awk '/inet /{print $2}'` salt-master \"salt-master, consul-server, monitoring-server\""
	  ]
	}
	provisioner "remote-exec" {
	  inline = [
		     "sudo yum install salt-master -y",
		     "sudo yum install salt-minion -y",
		     "sudo yum install python-pip -y",
		     "sudo yum install GitPython -y",
		     "sudo service salt-master stop",
		     "sudo mv /home/butler/master /etc/salt/master",       
		     "sudo service salt-master start",
		     "sudo hostname salt-master",
		     "sudo semodule -i collectdlocal.pp",
	  ]
	}
}