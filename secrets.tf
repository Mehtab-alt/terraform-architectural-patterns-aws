# secrets.tf
# Fetches sensitive data from AWS Secrets Manager at runtime.
# This prevents secrets from ever being stored in version control.

data "aws_secretsmanager_secret_version" "database" {
  # The secret ID is dynamically constructed based on the active workspace
  # Example Secret IDs: "cascade-app/dev/db_credentials", "cascade-app/prod/db_credentials"
  secret_id = "${var.project_name}/${terraform.workspace}/db_credentials"
}

locals {
  # Securely parse the fetched secret JSON string into a Terraform map
  # Assumes the secret in AWS is a JSON string with keys "username" and "password"
  database_credentials = jsondecode(data.aws_secretsmanager_secret_version.database.secret_string)
}
