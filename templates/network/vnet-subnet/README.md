# VNet + Subnets Module

This module creates an Azure Virtual Network with multiple subnets. It's designed to be flexible and support various subnet configurations including private endpoints, service endpoints, and subnet delegation. 

## Features

- Creates a single Virtual Network with multiple subnets
- Support for private endpoint network policies configuration (enabled by default for security)
- Optional service endpoints for Azure PaaS integration
- Optional subnet delegation for specialized services
- Comprehensive input validation and flexible tagging support

## Usage

### Basic Usage

For direct module usage where you manage subnet names explicitly:

```hcl
resource "random_string" "suffix" {
  length  = 3
  upper   = false
  special = false
  numeric = true
}

module "network" {
  source = "git::https://github.com/mccrackenyyc/terraform-modules.git//templates/network/vnet-subnet?ref=main"
  
  resource_group_name = "myapp-dev-rg-core"
  location           = "canadacentral"
  vnet_name          = "myapp-dev-vnet-core-${random_string.suffix.result}"
  vnet_address_space = ["10.0.0.0/16"]
  
  subnets = {
    app = {
      subnet_name      = "myapp-dev-snet-app-${random_string.suffix.result}"
      address_prefixes = ["10.0.1.0/24"]
    }
    data = {
      subnet_name       = "myapp-dev-snet-data-${random_string.suffix.result}"
      address_prefixes  = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  }
  
  tags = {
    Environment = "dev"
    Project     = "myapp"
    ManagedBy   = "terraform"
  }
}
```

### Advanced Integration Pattern

For consuming projects that want to dynamically generate subnet names from variables:

```hcl
# In your consuming project's variables.tf
variable "workload" {
  description = "Workload identifier"
  type        = string
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "subnets" {
  description = "Subnets to create"
  type = map(object({
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

# In your consuming project's network.tf
resource "random_string" "suffix" {
  length  = 3
  upper   = false
  special = false
  numeric = true
}

module "network" {
  source = "git::https://github.com/mccrackenyyc/terraform-modules.git//templates/network/vnet-subnet?ref=main"
  
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  vnet_name          = "${var.workload}-${var.env}-vnet-core-${random_string.suffix.result}"
  vnet_address_space = var.vnet_address_space
  
  # Transform subnets to include computed names
  subnets = {
    for key, config in var.subnets : key => merge(config, {
      subnet_name = "${var.workload}-${var.env}-snet-${key}-${random_string.suffix.result}"
    })
  }
  
  tags = local.tags
}

# In your tfvars
subnets = {
  app = {
    address_prefixes = ["10.0.1.0/24"]
  }
  data = {
    address_prefixes  = ["10.0.2.0/24"]
    service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
  }
}
```

**Why use the transformation pattern?**
- Keeps tfvars clean and business-focused (no repetitive naming)
- Centralizes naming logic in one place
- Allows dynamic injection of variables (workload, environment) into subnet names
- Makes adding new subnets simpler - just add to tfvars without managing names

### Advanced Subnet Configurations

```hcl
subnets = {
  # Basic subnet
  app = {
    subnet_name      = "myapp-dev-snet-app-abc"
    address_prefixes = ["10.0.1.0/24"]
  }
  
  # Subnet with service endpoints
  data = {
    subnet_name       = "myapp-dev-snet-data-abc"
    address_prefixes  = ["10.0.2.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
  }
  
  # Private endpoint subnet
  private_endpoints = {
    subnet_name                       = "myapp-dev-snet-pe-abc"
    address_prefixes                  = ["10.0.3.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
  
  # Subnet with delegation (Azure Container Instances)
  containers = {
    subnet_name      = "myapp-dev-snet-aci-abc"
    address_prefixes = ["10.0.4.0/24"]
    delegation = {
      name = "aci-delegation"
      service_delegation = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
  
  # App Service subnet with delegation and service endpoints
  app_service = {
    subnet_name       = "myapp-dev-snet-app-service-abc"
    address_prefixes  = ["10.0.5.0/24"]
    service_endpoints = ["Microsoft.Web", "Microsoft.KeyVault"]
    delegation = {
      name = "app-service-delegation"
      service_delegation = {
        name = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.12 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_servers"></a> [dns_servers](#input_dns_servers) | List of DNS servers for the VNet | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input_location) | Azure region for resources | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input_subnets) | Map of subnets to create | <pre>map(object({<br>    subnet_name                       = string<br>    address_prefixes                  = list(string)<br>    private_endpoint_network_policies = optional(string, "Enabled")<br>    service_endpoints                 = optional(list(string), [])<br>    delegation = optional(object({<br>      name = string<br>      service_delegation = object({<br>        name    = string<br>        actions = optional(list(string), [])<br>      })<br>    }), null)<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input_tags) | Tags to apply to resources | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet_address_space](#input_vnet_address_space) | Address space for the virtual network | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet_name](#input_vnet_name) | Name of the virtual network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_address_prefixes"></a> [subnet_address_prefixes](#output_subnet_address_prefixes) | Map of subnet names to their address prefixes |
| <a name="output_subnet_ids"></a> [subnet_ids](#output_subnet_ids) | Map of subnet names to their IDs |
| <a name="output_subnet_names"></a> [subnet_names](#output_subnet_names) | Map of subnet keys to their names |
| <a name="output_vnet_address_space"></a> [vnet_address_space](#output_vnet_address_space) | Address space of the virtual network |
| <a name="output_vnet_id"></a> [vnet_id](#output_vnet_id) | ID of the virtual network |
| <a name="output_vnet_location"></a> [vnet_location](#output_vnet_location) | Location of the virtual network |
| <a name="output_vnet_name"></a> [vnet_name](#output_vnet_name) | Name of the virtual network |
| <a name="output_vnet_resource_group_name"></a> [vnet_resource_group_name](#output_vnet_resource_group_name) | Resource group name of the virtual network |
<!-- END_TF_DOCS -->

## License

This module is available under the MIT License.