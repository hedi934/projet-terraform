resource "azurerm_storage_account" "projet_azstorage" {
  name                     = "azstorageesgielectif"
  resource_group_name      = azurerm_resource_group.projet_terraform.name
  location                 = azurerm_resource_group.projet_terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "projet_terraform" {
  name                 = "sharename"
  storage_account_name = azurerm_storage_account.projet_azstorage.name
  quota                = 50

  acl {
    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}