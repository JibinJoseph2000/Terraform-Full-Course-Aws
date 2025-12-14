data "aws_vpc" "demo-vpc" {
  filter {
    name = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet" "demo-subnet"{
  filter {
    name = "tag:Name"
    values = ["subneta"]
  }

  vpc_id = data.aws_vpc.demo-vpc.id
}

data "aws_ami" "linux2"{
  owners = ["amazon"]
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "demo_instance" {
  ami           = data.aws_ami.linux2.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.demo-subnet.id
  tags = var.tags
}
