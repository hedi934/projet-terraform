
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
  client_id       = var.client_id
  client_secret   = var.client_secret 
}

locals {
  group_name = "FYC"
  location = "francecentral"
}

# Création d’un réseau virtuel
resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-network"
    address_space       = ["10.0.0.0/24"]
    location            = local.location
    resource_group_name = local.group_name
}

# Création du sous-réseau virtuel
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = local.group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/28"]
}

# Création de l'adresse IP publique
resource "azurerm_public_ip" "main" {
  name                    = "${var.prefix}-publicIP-${count.index}"
  location                = local.location
  resource_group_name     = local.group_name
  allocation_method       = "Static"
  count                   = 2
}

# Création du groupe de sécurité réseau
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-acceptanceTestSecurityGroup"
  location            = local.location
  resource_group_name = local.group_name
  
  security_rule {
    name                       = "${var.prefix}-rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80","8081"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Création d'une carte réseau virtuelle
resource "azurerm_network_interface" "main" {
    name                        = "${var.prefix}-NIC${count.index}"
    location                    = local.location
    resource_group_name         = local.group_name
    count                       = 2

    ip_configuration {
        name                          = "${var.prefix}NICConfig${count.index}"
        subnet_id                     = azurerm_subnet.internal.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.main[count.index].id
    }
}

resource "azurerm_network_interface_security_group_association" "main" {
    count = length(azurerm_network_interface.main)
    network_interface_id      = azurerm_network_interface.main[count.index].id
    network_security_group_id = azurerm_network_security_group.main.id
}

# Création des machines virtuelles de déploiement 
resource "azurerm_linux_virtual_machine" "vm-b1s" {
    count                 = 2
    name                  = "${var.prefix}-VM-deploy"
    location              = local.location
    resource_group_name   = local.group_name
    network_interface_ids = ["${azurerm_network_interface.main[count.index].id}"]
    size                  = "Standard_B1s"

    os_disk {
        name              = "${var.prefix}-OsDisk${count.index}"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    admin_ssh_key {
      username   = "azureuser"
      public_key = file("~/.ssh/id_rsa.pub")
    }

    source_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "18.04-LTS" 
      version   = "latest"
    }

    computer_name  = "vm-ubuntu-b1s"
    admin_username = "azureuser"
}

