resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

resource "azurerm_traffic_manager_profile" "projet_terraform" {
  name                = random_id.server.hex
  resource_group_name = azurerm_resource_group.projet_terraform.name

  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = random_id.server.hex
    ttl           = 100
  }

  monitor_config {
    protocol                     = "http"
    port                         = 80
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }

}

resource "azurerm_traffic_manager_endpoint" "projet_terraform" {
  name                = random_id.server.hex
  resource_group_name = azurerm_resource_group.projet_terraform.name
  profile_name        = azurerm_traffic_manager_profile.projet_terraform.name
  target              = "terraform.io"
  type                = "externalEndpoints"
  weight              = 100
}