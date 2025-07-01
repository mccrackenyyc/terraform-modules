variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)

  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "At least one address space must be specified."
  }
}

# Example subnet configuration:
# subnets = {
#   app = {
#     subnet_name      = "myapp-dev-snet-app-abc"
#     address_prefixes = ["10.0.1.0/24"]
#   }
#   data = {
#     subnet_name       = "myapp-dev-snet-data-abc"
#     address_prefixes  = ["10.0.2.0/24"]
#     service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
#   }
# }
variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    subnet_name                       = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Enabled")
    service_endpoints                 = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }), null)
  }))
}

variable "dns_servers" {
  description = "List of DNS servers for the VNet"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}