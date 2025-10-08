# This file contains the logic for the Configuration Cascade.
# It defines a common base and merges environment-specific overrides.

locals {
  # 1. The Common Base Configuration (The "DNA" of our infrastructure)
  common_config = {
    instance_count           = 1
    instance_type            = "t2.micro"      # Smallest, safest default
    monitoring_agent_enabled = false           # Monitoring is disabled by default
    tags = {
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Workspace   = terraform.workspace
    }
  }

  # 2. Environment-Specific Overrides
  # Each map contains ONLY the values that are different from the common base.
  environment_overrides = {
    staging = {
      instance_count = 2
      instance_type  = "t2.medium"
    }
    prod = {
      instance_count           = 4
      instance_type            = "t3.large"
      monitoring_agent_enabled = true # Enable monitoring only for production
      tags = {
        CostCenter = "PROD-123" # Example of adding a prod-only tag
      }
    }
    # 'dev' is not listed, so it will fall back to using the 'common_config' directly.
  }

  # 3. The Cascade Logic (Robust Merge)
  # This logic correctly merges nested maps like 'tags'.
  workspace_override = lookup(local.environment_overrides, terraform.workspace, {})

  active_config = {
    instance_count           = lookup(local.workspace_override, "instance_count", local.common_config.instance_count)
    instance_type            = lookup(local.workspace_override, "instance_type", local.common_config.instance_type)
    monitoring_agent_enabled = lookup(local.workspace_override, "monitoring_agent_enabled", local.common_config.monitoring_agent_enabled)
    tags                     = merge(local.common_config.tags, lookup(local.workspace_override, "tags", {}))
  }
}
