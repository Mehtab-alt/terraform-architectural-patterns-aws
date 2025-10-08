# This file defines WHAT resources to create, using the 'active_config'
# determined by our cascade logic in config.tf.

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  count         = local.active_config.instance_count
  instance_type = local.active_config.instance_type
  tags          = local.active_config.tags
  ami           = var.ami_id
}

# This resource is conditionally created based on the 'monitoring_agent_enabled' flag.
# It will only exist in environments where the flag is set to 'true' (i.e., prod).
resource "aws_ssm_association" "monitoring_agent" {
  count = local.active_config.monitoring_agent_enabled ? 1 : 0

  name = "AmazonCloudWatch-ManageAgent"
  targets {
    key    = "InstanceIds"
    values = aws_instance.web_server.*.id
  }
}

# Example of consuming a fetched secret for a hypothetical database.
# This resource block is for demonstration purposes.
resource "aws_db_instance" "example_db" {
  count = 0 # Disabled for this example to prevent actual cost

  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "${var.project_name}_${terraform.workspace}"
  skip_final_snapshot  = true

  # These values are securely fetched at runtime, not stored in code.
  username = local.database_credentials.username
  password = local.database_credentials.password
}
