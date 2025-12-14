
variable "instance_count" {
    description = "Number of EC2 instance to create"
    type = number
}

variable "region" {
    description = "AWS region to deploy resources"
    type = string
    default = "us-east-1"
}

variable "environment" {
    type = string
    default = "dev"
}

variable "monitoring_enabled" {
    description = "Enable detailed monitoring"
    type = bool
    default = true
}

variable "associate_public_ip" {
    description = "Associate a public IP address"
    type = bool
    default = true
}

variable "allowed_vm_types" {
  type = list(string)
  default = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "cidr_block" {
  description = "cidr block for vpc"
  type = list(string)
  default = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12"]
}

variable "allowed_regions" {
    description = "List of allowed AWS regions"
    type = set(string)
    default = ["us-east-1","us-west-2", "eu-west-1"] 
}

variable tags {
    description = "Tags to apply to resources"
    type = map(string)
    default = {
        environment = "dev"
        name        = "dev-instance"
        project     = "terraform-aws"
        created_by  = "terraform"
    }
}

variable "ingress_values" {
  description = "ingress values for security group"
  type = tuple([ number,string,number ])
  default = [443, "tcp", 443] 
}

variable "config" {
    type = object({
      region = string
      monitoring_enabled = bool
    })
    default = {
      region = "us-east-1"
      monitoring_enabled = true
    }
  
}

variable bucket_names{
  description = "List of S3 bucket names"
  type = list(string)
  default = ["terraform-aws-demo-bucket-one-123456", "terraform-aws-demo-bucket-two-123456"]
}

variable "bucket_name_set"{
  description = "Set of S3 bucket names"
  type = set(string)
  default = ["terraform-aws-demo-bucket-three-123456", "terraform-aws-demo-bucket-four-123456"]
}

variable "ingress_rules" {
  description = "List of ingress rules for security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS"
    }
  ]
}