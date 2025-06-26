# VNet + Subnets Module

This module creates an Azure Virtual Network with multiple subnets. It's designed to be flexible and support various subnet configurations including private endpoints, service endpoints, and subnet delegation.

## Features

- Creates a single Virtual Network with multiple subnets
- Support for private endpoint network policies
- Optional service endpoints for Azure PaaS integration
- Optional subnet delegation for specialized services
- Comprehensive input validation
- Flexible tagging support

## Usage

### Basic Example

```hcl
# Deployment-wide random suffix
resource "random_string" "suffix" {
  length  = 3
  upper   = false
  special = false
  numeric = true
}

module "network" {
  source = "../../modules/network/vnet-subnet"
  
  resource_group_name = "runready-dev-rg-main-${random_string.suffix.result}"
  location           = "canadacentral"
  vnet_name          = "runready-dev-vnet-main-${random_string.suffix.result}"
  vnet_address_space = ["10.0.0.0/16"]
  
  subnets = {
    "runready-dev-snet-app-${random_string.suffix.result}" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "runready-dev-snet-data-${random_string.suffix.result}" = {
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
  }
  
  tags = {
    Environment = "dev"
    Project     = "runready"
    Owner       = "devops-team"
  }
}
```

### Advanced Example with Private Endpoints

```hcl
# Deployment-wide random suffix
resource "random_string" "suffix" {
  length  = 3
  upper   = false
  special = false
  numeric = true
}

module "network" {
  source = "../../modules/network/vnet-subnet"
  
  resource_group_name = "runready-prd-rg-main-${random_string.suffix.result}"
  location           = "canadacentral"
  vnet_name          = "runready-prd-vnet-main-${random_string.suffix.result}"
  vnet_address_space = ["10.0.0.0/16"]
  
  subnets = {
    "runready-prd-snet-app-${random_string.suffix.result}" = {
      address_prefixes = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Web"]
    }
    "runready-prd-snet-data-${random_string.suffix.result}" = {
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
    }
    "runready-prd-snet-pe-${random_string.suffix.result}" = {
      address_prefixes = ["10.0.3.0/24"]
      private_endpoint_network_policies_enabled = false
    }
  }
  
  dns_servers = ["168.63.129.16", "8.8.8.8"]
  
  tags = {
    Environment = "prd"
    Project     = "runready"
    Owner       = "devops-team"
    CostCenter  = "engineering"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.12 |
| azurerm | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region for resources | `string` | n/a | yes |
| vnet_name | Name of the virtual network | `string` | n/a | yes |
| subnets | Map of subnets to create | `map(object({...}))` | n/a | yes |
| vnet_address_space | Address space for the virtual network | `list(string)` | `["10.0.0.0/16"]` | no |
| dns_servers | List of DNS servers for the VNet | `list(string)` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID of the virtual network |
| vnet_name | Name of the virtual network |
| vnet_address_space | Address space of the virtual network |
| vnet_location | Location of the virtual network |
| vnet_resource_group_name | Resource group name of the virtual network |
| subnet_ids | Map of subnet names to their IDs |
| subnet_names | Map of subnet keys to their names |
| subnet_address_prefixes | Map of subnet names to their address prefixes |

## Subnet Configuration

The `subnets` variable accepts a map where each key is the subnet name and the value is an object with the following properties:

- **address_prefixes** (required): List of address prefixes for the subnet
- **private_endpoint_network_policies** (optional): Enable network policies for private endpoints (default: true)
- **service_endpoints** (optional): List of service endpoints to enable (default: [])
- **delegation** (optional): Subnet delegation configuration for specialized services

### Subnet Configuration Examples

```hcl
subnets = {
  # Basic subnet
  "app-subnet" = {
    address_prefixes = ["10.0.1.0/24"]
  }
  
  # Subnet with service endpoints
  "data-subnet" = {
    address_prefixes = ["10.0.2.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.Storage"]
  }
  
  # Private endpoint subnet
  "private-endpoint-subnet" = {
    address_prefixes = ["10.0.3.0/24"]
    private_endpoint_network_policies = false
  }
  
  # Subnet with delegation (example: Azure Container Instances)
  "container-subnet" = {
    address_prefixes = ["10.0.4.0/24"]
    delegation = {
      name = "aci-delegation"
      service_delegation = {
        name    = "Microsoft.ContainerInstance/containerGroups"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
  }
  
  # Complex subnet with multiple configurations
  "app-service-subnet" = {
    address_prefixes = ["10.0.5.0/24"]
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

### Common Service Endpoints

- `Microsoft.Storage` - Azure Storage Account
- `Microsoft.Sql` - Azure SQL Database
- `Microsoft.Web` - Azure App Service
- `Microsoft.KeyVault` - Azure Key Vault

## Validation Rules

- Resource group name cannot be empty
- Location must be a valid Azure region
- VNet name must follow Azure naming conventions (1-64 characters, alphanumeric, hyphens, periods, underscores)
- At least one address space must be specified
- At least one subnet must be defined

## Security Considerations

- Private endpoint network policies are enabled by default for security
- Service endpoints should only be enabled for required services
- Consider using private endpoints for enhanced security over service endpoints
- DNS servers default to Azure-provided DNS but can be customized

## License

This module is part of the RunReady project and is available under the project's license terms.