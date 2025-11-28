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
  region = "us-east-1"
}

# Create aws s3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "jibin-demo-bucket-12345"

  tags = {
    Name        = "My bucket 2.0"
    Environment = "Dev"
  }
}
