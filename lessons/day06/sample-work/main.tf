

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