terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.primary
  alias = "primary"
}

provider "aws" {
  region = var.secondary
  alias = "secondary"
}

provider "aws" {
  region = var.tertiary
  alias = "tertiary"
}

