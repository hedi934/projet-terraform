resource "azurerm_storage_account" "projet_azfunction" {
  name                     = "azfunctionesgielectif"
  resource_group_name      = azurerm_resource_group.projet_terraform.name
  location                 = azurerm_resource_group.projet_terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "projet_fuctionapp" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.projet_terraform.location
  resource_group_name = azurerm_resource_group.projet_terraform.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "projet_terraform" {
  name                       = "azure-functionsesgielectif"
  location                   = azurerm_resource_group.projet_terraform.location
  resource_group_name        = azurerm_resource_group.projet_terraform.name
  app_service_plan_id        = azurerm_app_service_plan.projet_fuctionapp.id
  storage_account_name       = azurerm_storage_account.projet_azfunction.name
  storage_account_access_key = azurerm_storage_account.projet_azfunction.primary_access_key
}