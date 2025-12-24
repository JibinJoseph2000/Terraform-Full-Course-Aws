resource "aws_vpc" "primary_vpc" {
  cidr_block = var.primary_vpc_cidr
  provider = aws.primary
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Primary-VPC-${var.primary}"
  }
}

resource "aws_vpc" "secondary_vpc" {
  cidr_block = var.secondary_vpc_cidr
  provider = aws.secondary
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Secondary-VPC-${var.secondary}"
  }
}

resource "aws_vpc" "tertiary_vpc" {
  cidr_block = var.tertiary_vpc_cidr
  provider = aws.tertiary
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Tertiary-VPC-${var.tertiary}"
  }
}

resource "aws_subnet" "primary_subnet" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary_vpc.id
  cidr_block              = var.primary_subnet_cidr
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "Primary-Subnet-${var.primary}"
    Environment = "Demo"
  }
}

resource "aws_subnet" "secondary_subnet" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary_vpc.id
  cidr_block              = var.secondary_subnet_cidr
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "Secondary-Subnet-${var.secondary}"
    Environment = "Demo"
  }
}

resource "aws_subnet" "tertiary_subnet" {
  provider                = aws.tertiary
  vpc_id                  = aws_vpc.tertiary_vpc.id
  cidr_block              = var.tertiary_subnet_cidr
  availability_zone       = data.aws_availability_zones.tertiary.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name        = "Tertiary-Subnet-${var.tertiary}"
    Environment = "Demo"
  }
}

resource "aws_security_group" "jump_sg" {
  provider    = aws.primary
  name        = "jump-server-sg"
  description = "Security group for Jump Server"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = ["<YOUR_PUBLIC_IP>/32"]  # e.g. 49.xx.xx.xx/32
    cidr_blocks = ["111.92.80.121/32"]  # e.g. 49.xx.xx.xx/32
    

  }

  egress {
    description = "Allow outbound to private EC2s"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jump-Server-SG"
  }
}

resource "aws_instance" "jump_server" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.jump_sg.id]
  key_name               = var.jump_key_name

  associate_public_ip_address = true

  tags = {
    Name        = "Jump-Server"
    Environment = "Demo"
  }
}

resource "aws_internet_gateway" "primary_igw"{
  provider = aws.primary
  vpc_id = aws_vpc.primary_vpc.id

  tags = {
    Name = "Primary-IGW-${var.primary}"
    Environment = "Demo"
  }
}

resource "aws_route" "primary_internet_access" {
  provider               = aws.primary
  route_table_id         = aws_route_table.primary_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary_igw.id
}

# resource "aws_internet_gateway" "secondary-igw"{
#   provider = aws.secondary
#   vpc_id = aws_vpc.secondary_vpc.id

#   tags = {
#     Name = "Secondary-IGW-${var.secondary}"
#     Environment = "Demo"
#   }
# }

resource "aws_route_table" "primary_rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary_vpc.id

  # route {
  #   cidr_block = var.secondary_vpc_cidr
  #   vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  # }

  tags = {
    Name        = "Primary-Route-Table"
    Environment = "Demo"
  }
}

resource "aws_route_table" "secondary_rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary_vpc.id

  # route {
  #   cidr_block = var.primary_vpc_cidr
  #   vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  # }

  tags = {
    Name        = "Secondary-Route-Table"
    Environment = "Demo"
  }
}

resource "aws_route_table" "tertiary_rt" {
  provider = aws.tertiary
  vpc_id   = aws_vpc.tertiary_vpc.id


  tags = {
    Name        = "Tertiary-Route-Table"
    Environment = "Demo"
  }
}

resource "aws_route_table_association" "primary_rta" {
  provider      = aws.primary
  subnet_id     = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.primary_rt.id
  
}

resource "aws_route_table_association" "secondary_rta" {
  provider      = aws.secondary
  subnet_id     = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.secondary_rt.id
  
}

resource "aws_route_table_association" "tertiary_rta" {
  provider      = aws.tertiary
  subnet_id     = aws_subnet.tertiary_subnet.id
  route_table_id = aws_route_table.tertiary_rt.id
  
}

resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.secondary_vpc.id
  peer_region = var.secondary
  auto_accept = false

  tags = {
    Name        = "Primary-to-Secondary-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "secondary_accepter" {
  provider    = aws.secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept = true

  tags = {
    Name        = "Secondary-to-Primary-Peering"
    Environment = "Demo"
    Side        = "Accepter"
  }
}

resource "aws_vpc_peering_connection" "secondary_to_tertiary" {
  provider    = aws.secondary
  vpc_id      = aws_vpc.secondary_vpc.id
  peer_vpc_id = aws_vpc.tertiary_vpc.id
  peer_region = var.tertiary
  auto_accept = false

  tags = {
    Name        = "Secondary-to-Tertiary-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
  
}

resource "aws_vpc_peering_connection_accepter" "tertiary_accepter" {
  provider    = aws.tertiary
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id
  auto_accept = true

  tags = {
    Name        = "Tertiary-to-Secondary-Peering"
    Environment = "Demo"
    Side        = "Accepter"
  }
  
}

resource "aws_vpc_peering_connection" "primary_to_tertiary" {
  provider    = aws.primary
  vpc_id      = aws_vpc.primary_vpc.id
  peer_vpc_id = aws_vpc.tertiary_vpc.id
  peer_region = var.tertiary
  auto_accept = false

  tags = {
    Name        = "Primary-to-Tertiary-Peering"
    Environment = "Demo"
    Side        = "Requester"
  }
  
}

resource "aws_vpc_peering_connection_accepter" "tertiary_primary_accepter" {
  provider    = aws.tertiary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_tertiary.id
  auto_accept = true

  tags = {
    Name        = "Tertiary-to-Primary-Peering"
    Environment = "Demo"
    Side        = "Accepter"
  }
  
}

resource "aws_route" "primary_to_secondary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

resource "aws_route" "secondary_to_primary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

resource "aws_route" "secondary_to_tertiary" {
  provider                  = aws.secondary
  route_table_id            = aws_route_table.secondary_rt.id
  destination_cidr_block    = var.tertiary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id

  depends_on = [aws_vpc_peering_connection_accepter.tertiary_accepter]
}

resource "aws_route" "tertiary_to_secondary" {
  provider                  = aws.tertiary
  route_table_id            = aws_route_table.tertiary_rt.id
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.secondary_to_tertiary.id

  depends_on = [aws_vpc_peering_connection_accepter.tertiary_accepter]
}

resource "aws_route" "primary_to_tertiary" {
  provider                  = aws.primary
  route_table_id            = aws_route_table.primary_rt.id
  destination_cidr_block    = var.tertiary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_tertiary.id

  depends_on = [aws_vpc_peering_connection_accepter.tertiary_primary_accepter]
}

resource "aws_route" "tertiary_to_primary" {
  provider                  = aws.tertiary
  route_table_id            = aws_route_table.tertiary_rt.id
  destination_cidr_block    = var.primary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_tertiary.id

  depends_on = [aws_vpc_peering_connection_accepter.tertiary_primary_accepter]
}

resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name        = "primary-vpc-sg"
  description = "Security group for Primary VPC instance"
  vpc_id      = aws_vpc.primary_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.jump_sg.id]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr, var.tertiary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Primary-VPC-SG"
    Environment = "Demo"
  }
}

# Security Group for Secondary VPC EC2 instance
resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name        = "secondary-vpc-sg"
  description = "Security group for Secondary VPC instance"
  vpc_id      = aws_vpc.secondary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.primary_vpc_cidr, var.tertiary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr,var.tertiary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Secondary-VPC-SG"
    Environment = "Demo"
  }
}

resource "aws_security_group" "tertiary_sg" {
  provider    = aws.tertiary
  name        = "tertiary-vpc-sg"
  description = "Security group for Tertiary VPC instance"
  vpc_id      = aws_vpc.tertiary_vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.primary_vpc_cidr]
  }

  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.secondary_vpc_cidr,var.primary_vpc_cidr]
  }

  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.secondary_vpc_cidr,var.primary_vpc_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Tertiary-VPC-SG"
    Environment = "Demo"
  }
}

resource "aws_instance" "primary_instance" {
  provider               = aws.primary
  ami                    = data.aws_ami.primary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.primary_subnet.id
  vpc_security_group_ids = [aws_security_group.primary_sg.id]
  key_name               = var.primary_key_name

  user_data = local.primary_user_data

  tags = {
    Name        = "Primary-VPC-Instance"
    Environment = "Demo"
    Region      = var.primary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

# EC2 Instance in Secondary VPC
resource "aws_instance" "secondary_instance" {
  provider               = aws.secondary
  ami                    = data.aws_ami.secondary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.secondary_subnet.id
  vpc_security_group_ids = [aws_security_group.secondary_sg.id]
  key_name               = var.secondary_key_name

  user_data = local.secondary_user_data

  tags = {
    Name        = "Secondary-VPC-Instance"
    Environment = "Demo"
    Region      = var.secondary
  }

  depends_on = [aws_vpc_peering_connection_accepter.secondary_accepter]
}

resource "aws_instance" "tertiary_instance" {
  provider               = aws.tertiary
  ami                    = data.aws_ami.tertiary_ami.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.tertiary_subnet.id
  vpc_security_group_ids = [aws_security_group.tertiary_sg.id]
  key_name               = var.tertiary_key_name

  user_data = local.tertiary_user_data

  tags = {
    Name        = "Tertiary-VPC-Instance"
    Environment = "Demo"
    Region      = var.tertiary
  }

  depends_on = [aws_vpc_peering_connection_accepter.tertiary_accepter]
}





