# create storage account
resource "azurerm_storage_account" "butler_storage" {
    name = "butlerstorage1337"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    location = "${var.region}"
    account_type = "Standard_LRS"

    tags {
        environment = "dev"
    }
}

# create storage container
resource "azurerm_storage_container" "butler_storage_container" {
    name = "butlersc"
    resource_group_name = "${azurerm_resource_group.butler_dev.name}"
    storage_account_name = "${azurerm_storage_account.butler_storage.name}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.butler_storage"]
}