# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

    subscription_id = "56327ea7-f66b-4ff8-9db7-4fad269d3ce3"
    client_id       = "ed412fb5-def8-463a-83e3-4935966c31c3"
    client_secret   = "KHU8Q~weQzT6mCKKzvw3c5X7WBZHL.AW1pN5lcRf"
    tenant_id       = "4888e0d4-74a3-4b37-90c5-cb1214a39c88"

}

resource "azurerm_resource_group" "NGR" {
  name     = "NGR-resources"
  location = "Australia East"
}

resource "azurerm_virtual_network" "NGR" {
  name                = "NGR-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.NGR.location
  resource_group_name = azurerm_resource_group.NGR.name
}

resource "azurerm_subnet" "NGR" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.NGR.name
  virtual_network_name = azurerm_virtual_network.NGR.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "NGR" {
  name                = "NGR-nic"
  location            = azurerm_resource_group.NGR.location
  resource_group_name = azurerm_resource_group.NGR.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.NGR.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "NGR" {
  name                = "NGR-machine"
  resource_group_name = azurerm_resource_group.NGR.name
  location            = azurerm_resource_group.NGR.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.NGR.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}