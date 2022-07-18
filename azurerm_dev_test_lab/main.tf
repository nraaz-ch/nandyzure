
resource "azurerm_resource_group" "ng" {
  name     = "ng-lab"
  location = "West Europe"
}

resource "azurerm_dev_test_lab" "example" {
  name                = "ngr-devtestlab"
  location            = azurerm_resource_group.ng.location
  resource_group_name = azurerm_resource_group.ng.name

  tags = {
    "Sydney" = "Australia"
  }
}