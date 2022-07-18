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
