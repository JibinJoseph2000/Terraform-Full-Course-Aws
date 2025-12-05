resource "aws_instance" "demo_instance" {
  ami           = "ami-0ff8a91507f77f867"
  count = var.instance_count
#   instance_type = "t3.micro"
    instance_type = var.tags.environment == "dev" ? "t2.micro" : "t3.micro"

  tags = var.tags
}

resource "aws_security_group" "ingress_rules" {
  name   = "sg"
# ingress hard coded values
#   ingress {
#     from_port   = 80
#     protocol    = "HTTP"
#     to_port     = 80
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# ingress using dynamic block
dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
}

}

locals {
  all_instance_ids = aws_instance.demo_instance[*].id
}

output "instances" {
  value = local.all_instance_ids 
}