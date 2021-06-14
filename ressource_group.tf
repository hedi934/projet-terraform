
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = ">=2.0.0"
  }
}

provider "azurerm" {
  version = ">=2.0.0"
  features {}
  
  skip_provider_registration = true
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
 /* client_id       = var.client_id
  client_secret   = var.client_secret */
}

resource "azurerm_resource_group" "projet_terraform" {
  name     = var.projet
  location = var.location
}