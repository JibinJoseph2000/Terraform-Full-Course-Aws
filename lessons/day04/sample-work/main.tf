terraform {
    backend "s3" {
    bucket = "demo-terraform-state-bucket-12345"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create aws s3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "terraform-aws-demo-bucket-12345"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}