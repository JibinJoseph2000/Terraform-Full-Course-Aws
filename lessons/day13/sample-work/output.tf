output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.demo_instance.id
}

output "vpc_id" {
  description = "VPC ID from data source"
  value       = data.aws_vpc.demo-vpc.id
}

output "subnet_id" {
  description = "Subnet ID from data source"
  value       = data.aws_subnet.demo-subnet.id
}

output "ami_id" {
  description = "AMI ID used for instance"
  value       = data.aws_ami.linux2.id
}