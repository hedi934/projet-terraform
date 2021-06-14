resource "azurerm_storage_account" "projet_hdinsight" {
  name                     = "hdinsightstoresgielectif"
  resource_group_name      = azurerm_resource_group.projet_terraform.name
  location                 = azurerm_resource_group.projet_terraform.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "projet_terraform" {
  name                  = "hdinsight"
  storage_account_name  = azurerm_storage_account.projet_hdinsight.name
  container_access_type = "private"
}

resource "azurerm_hdinsight_interactive_query_cluster" "projet_terraform" {
  name                = "hdiclusteresgielectif"
  resource_group_name = azurerm_resource_group.projet_terraform.name
  location            = azurerm_resource_group.projet_terraform.location
  cluster_version     = "3.6"
  tier                = "Standard"

  component_version {
    interactive_hive = "2.1"
  }

  gateway {
    enabled  = true
    username = "acctestusrgw"
    password = "TerrAform123!"
  }

  storage_account {
    storage_container_id = azurerm_storage_container.projet_terraform.id
    storage_account_key  = azurerm_storage_account.projet_hdinsight.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size  = "Standard_D13_V2"
      username = "acctestusrvm"
      password = "AccTestvdSC4daf986!"
    }

    worker_node {
      vm_size               = "Standard_D14_V2"
      username              = "acctestusrvm"
      password              = "AccTestvdSC4daf986!"
      target_instance_count = 3
    }

    zookeeper_node {
      vm_size  = "Standard_A4_V2"
      username = "acctestusrvm"
      password = "AccTestvdSC4daf986!"
    }
  }
}