resource "azurerm_virtual_network" "butler_net" {
	depends_on = ["azurerm_resource_group.butler_dev"]
    name = "butler-net"
    address_space = ["10.0.0.0/16"]
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
}

# create subnet
resource "azurerm_subnet" "butler_subnet" {
    name = "butler_subnet"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    virtual_network_name = "${azurerm_virtual_network.butler_net.name}"
    address_prefix = "10.0.0.0/24"
}


