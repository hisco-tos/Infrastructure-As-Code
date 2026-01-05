terraform {
  required_version = ">= 1.14.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  # Use variable-driven region and optional profile.
  region  = var.aws_region
  profile = var.aws_profile != "" ? var.aws_profile : null
}

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional AWS CLI profile name to use (set in ~/.aws/credentials). Leave empty to use env creds."
  type        = string
  default     = "vscode"
}

