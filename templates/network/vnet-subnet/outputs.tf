output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

output "vnet_location" {
  description = "Location of the virtual network"
  value       = azurerm_virtual_network.main.location
}

output "vnet_resource_group_name" {
  description = "Resource group name of the virtual network"
  value       = azurerm_virtual_network.main.resource_group_name
}

output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "subnet_names" {
  description = "Map of subnet keys to their names"
  value       = { for k, v in azurerm_subnet.subnets : k => v.name }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value       = { for k, v in azurerm_subnet.subnets : k => v.address_prefixes }
}