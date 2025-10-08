# backend.tf
# Configures remote state storage in S3 with DynamoDB for state locking.
# This is non-negotiable for any collaborative or automated Terraform workflow.

terraform {
  backend "s3" {
    # IMPORTANT: Replace with your unique S3 bucket name
    bucket         = "your-unique-terraform-state-bucket-name"
    key            = "multi-env-cascade/terraform.tfstate"
    region         = "us-east-1"
    # IMPORTANT: Replace with your DynamoDB table name
    dynamodb_table = "your-terraform-lock-table-name"
    encrypt        = true
  }
}
