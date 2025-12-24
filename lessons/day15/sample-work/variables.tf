variable "primary" {
  default = "us-east-1"  
}

variable "secondary" {
  default = "us-west-2"  
}

variable "tertiary" {
  default = "ap-south-1"  
}

variable "primary_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "secondary_vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "tertiary_vpc_cidr" {
  default = "10.2.0.0/16"
}

variable "primary_subnet_cidr" {
  description = "CIDR block for the primary subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "secondary_subnet_cidr" {
  description = "CIDR block for the secondary subnet"
  type        = string
  default     = "10.1.1.0/24"
}

variable "tertiary_subnet_cidr" {
  description = "CIDR block for the tertiary subnet"
  type        = string
  default     = "10.2.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "primary_key_name" {
  description = "Name of the SSH key pair for Primary VPC instance (us-east-1)"
  type        = string
  default     = ""
}

variable "secondary_key_name" {
  description = "Name of the SSH key pair for Secondary VPC instance (us-west-2)"
  type        = string
  default     = ""
}

variable "tertiary_key_name" {
  description = "Name of the SSH key pair for Tertiary VPC instance (ap-south-1)"
  type        = string
  default     = ""
}

variable "jump_key_name" {
  description = "Name of the SSH key pair for Jump Server"
  type        = string
  default     = ""
}