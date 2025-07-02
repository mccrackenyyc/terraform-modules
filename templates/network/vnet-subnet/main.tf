# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers

  tags = var.tags
}

# Subnets
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                              = each.value.subnet_name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.main.name
  address_prefixes                  = each.value.address_prefixes
  private_endpoint_network_policies = each.value.private_endpoint_network_policies
  service_endpoints                 = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}