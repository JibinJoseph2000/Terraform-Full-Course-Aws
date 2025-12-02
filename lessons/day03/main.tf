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

# Create aws vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name = "demo-vpc"
  }
}

# Create aws s3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = "jibin-demo-bucket-12345"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    VPC         = aws_vpc.demo_vpc.id
  }
}