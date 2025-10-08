output "active_workspace" {
  description = "The currently selected Terraform workspace."
  value       = terraform.workspace
}

output "instance_ids" {
  description = "The IDs of the EC2 instances created."
  value       = aws_instance.web_server.*.id
}

output "instance_type_used" {
  description = "The instance type being used in this environment, determined by the cascade."
  value       = local.active_config.instance_type
}

output "instance_count_used" {
  description = "The number of instances deployed in this environment."
  value       = local.active_config.instance_count
}

output "instance_tags_used" {
  description = "The final merged tags applied to the instances."
  value       = local.active_config.tags
}

output "monitoring_agent_status" {
  description = "Indicates if the monitoring agent resource was enabled for this environment."
  value       = local.active_config.monitoring_agent_enabled ? "Enabled" : "Disabled"
}
