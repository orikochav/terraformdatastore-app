output "vm_public_ip_address" {
    value = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
}

output "vm_resource_group_name" {
    value = azurerm_linux_virtual_machine.mylinuxvm.resource_group_name
}

output "vm_resource_group_location" {
    value = azurerm_linux_virtual_machine.mylinuxvm.location
}
output "vm_network_interface_ids" {
    description = "we are geeting nic id from a datasoource tf file"
    value = [azurerm_linux_virtual_machine.mylinuxvm.network_interface_ids]
}