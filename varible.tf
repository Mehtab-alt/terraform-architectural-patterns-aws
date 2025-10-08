variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project, used for tagging and resource naming."
  type        = string
  default     = "cascade-app"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances. This is environment-specific."
  type        = string
  # No default, must be provided by a .tfvars file.
}
