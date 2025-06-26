variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string

  validation {
    condition = contains([
      "canadacentral", "canadaeast"
    ], var.location)
    error_message = "Location must be either 'canadacentral' or 'canadaeast'."
  }
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-._]{0,62}[a-zA-Z0-9]$", var.vnet_name))
    error_message = "VNet name must be 1-64 characters and contain only letters, numbers, hyphens, periods, and underscores."
  }
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]

  validation {
    condition     = length(var.vnet_address_space) > 0
    error_message = "At least one address space must be specified."
  }
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(bool, true)
    service_endpoints                 = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string), [])
      })
    }), null)
  }))

  validation {
    condition     = length(var.subnets) > 0
    error_message = "At least one subnet must be defined."
  }
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