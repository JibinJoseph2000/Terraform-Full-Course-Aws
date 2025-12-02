variable environment {
    default     = "dev"
}

variable "instance_count" {
    description = "Number of EC2 instance to create"
    type = number
}

variable "region" {
    description = "AWS region to deploy resources"
    type = string
    default = "us-east-1"
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

variable "cidr_block" {
  description = "cidr block for vpc"
  type = list(string)
  default = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12"]
}

variable "allowed_regions" {
    description = "List of allowed AWS regions"
    type = set(string)
    default = ["us-east-1", "us-west-2", "eu-west-1"] 
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