resource "azurerm_resource_group" "ng" {
  name     = "ng-app"
  location = "Australia East"
}

resource "azurerm_app_service_plan" "ngr" {
  name                = "ngr-appserviceplan"
  location            = azurerm_resource_group.ng.location
  resource_group_name = azurerm_resource_group.ng.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "ngr" {
  name                = "ngr-app-service"
  location            = azurerm_resource_group.ng.location
  resource_group_name = azurerm_resource_group.ng.name
  app_service_plan_id = azurerm_app_service_plan.ngr.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Databasengr"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}