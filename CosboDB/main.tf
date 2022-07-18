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

resource "azurerm_resource_group" "NG" {
  name     = "NG-resource-group"
  location = "West Europe"
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

resource "azurerm_cosmosdb_account" "db" {
  name                = "tfex-cosmos-db-${random_integer.ri.result}"
  location            = azurerm_resource_group.NG.location
  resource_group_name = azurerm_resource_group.NG.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  
  geo_location {
    location          = "eastus"
    failover_priority = 0
  }
}





