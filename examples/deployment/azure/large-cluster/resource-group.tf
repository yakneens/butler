resource "azurerm_resource_group" "butler_dev" {
    name = "butler_dev"
    location = "${var.region}"
}