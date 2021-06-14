resource "azurerm_app_service_plan" "projet_terraform" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.projet_terraform.location
  resource_group_name = azurerm_resource_group.projet_terraform.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "projet_terraform" {
  name                = "appserviceesgielectif"
  location            = azurerm_resource_group.projet_terraform.location
  resource_group_name = azurerm_resource_group.projet_terraform.name
  app_service_plan_id = azurerm_app_service_plan.projet_terraform.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}