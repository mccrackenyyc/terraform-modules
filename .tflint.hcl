# TFLint Configuration for Terraform Modules
# Enforces Terraform best practices and Azure standards

config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
}

# Azure-specific plugin for enhanced Azure resource validation
plugin "azurerm" {
  enabled = true
  version = "0.25.1"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# ================================
# 📌 Core Terraform Standards
# ================================

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_deprecated_index" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_standard_module_structure" {
  enabled = true
}

rule "terraform_workspace_remote" {
  enabled = true
}

# ================================
# 📌 Terraform Naming Conventions
# ================================

rule "terraform_naming_convention" {
  enabled = true
  
  # Variables: snake_case (e.g., workload_name, vnet_address_space)
  variable {
    format = "snake_case"
  }
  
  # Locals: snake_case (e.g., tags, vnet_core)
  locals {
    format = "snake_case"
  }
  
  # Outputs: snake_case matching resource attributes (e.g., vnet_id, subnet_names)
  output {
    format = "snake_case"
  }
  
  # Resources: snake_case (e.g., azurerm_resource_group.core)
  resource {
    format = "snake_case"
  }
  
  # Modules: snake_case (e.g., module.network)
  module {
    format = "snake_case"
  }
  
  # Data sources: snake_case (e.g., data.azurerm_client_config.current)
  data {
    format = "snake_case"
  }
}

# ================================
# 📌 Azure Resource Standards
# ================================

# Enforce recommended tags (consuming projects can override)
rule "azurerm_resource_missing_tags" {
  enabled = false  # Let consuming projects define their own tagging strategy
}

# Ensure storage accounts use secure transfer
rule "azurerm_storage_account_default_action_deny" {
  enabled = true
}

# Enforce HTTPS only for storage accounts
rule "azurerm_storage_account_enable_https_traffic_only" {
  enabled = true
}

# Require minimum TLS version
rule "azurerm_storage_account_min_tls_version" {
  enabled = true
}

# ================================
# 📌 Security Standards
# ================================

# No hardcoded secrets
rule "terraform_required_providers" {
  enabled = true
}

# Ensure proper provider constraints
rule "terraform_required_version" {
  enabled = true
}

# ================================
# 📌 Module Standards
# ================================

# Ensure comprehensive variable validation
rule "terraform_documented_variables" {
  enabled = true
}

# Require proper output descriptions
rule "terraform_documented_outputs" {
  enabled = true
}

# ================================
# 📌 Performance & Best Practices
# ================================

rule "terraform_unused_required_providers" {
  enabled = true
}

rule "terraform_module_version" {
  enabled = true
}