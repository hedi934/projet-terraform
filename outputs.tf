output "azurerm_linux_virtual_machine" {
  value  = azurerm_linux_virtual_machine.vm-b1s.*.private_ip_address
}


