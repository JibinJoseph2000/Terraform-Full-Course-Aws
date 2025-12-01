terraform {
    backend "s3" {
    bucket = "demo-terraform-state-bucket-12345"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    use_lockfile = false
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

variable environment {
    default     = "dev"
}

locals{
    bucket_name = "terraform-aws-demo-bucket-12345-${var.environment}"
    vpc_name    = "${var.environment}-vpc"
    instance_name = "${var.environment}-Instance"
}

output "details" {
  value = {
    bucket_id = aws_s3_bucket.demo-bucket.id
    bucket_arn = aws_s3_bucket.demo-bucket.arn
    vpc_id = aws_vpc.sample.id
    instance_id = aws_instance.name.id
  }
}


# Create aws s3 bucket
resource "aws_s3_bucket" "demo-bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = "${var.environment}-bucket"
    Environment = var.environment
  }
}

resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
  tags = {
    Environment = var.environment
    Name = local.vpc_name
  }
}

resource "aws_instance" "name" {
  ami = "ami-0e001c9271cf7f3b9"
    instance_type = "t2.micro"
    tags = {
        Environment = var.environment
        Name = local.instance_name
    }
}