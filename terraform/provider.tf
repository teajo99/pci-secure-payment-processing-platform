terraform {
  required_version = ">= 1.7.0"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "PCI Secure Payment Processing Platform"
      Environment = var.environment
      Owner       = "teajo99"
      ManagedBy   = "Terraform"
      Compliance  = "PCI-DSS"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
