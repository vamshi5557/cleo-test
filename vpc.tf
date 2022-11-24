 
resource "aws_vpc" "terra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
   tags = {
    Name = "terra_vpc"
  }
}


# Define Security group
# Looping ports by using dynamic blocks 

locals {
   ingress_rules = [{
      port        = 443
      description = "Ingress rules for port 443"
   },
   {
      port        = 80
      description = "Ingress rules for port 80"
   },
   {
      port        = 22
      description = "Ingress rules for port 22"
   }]
}



resource "aws_security_group" "terra-sg" {
   name   = "webports"
   vpc_id = aws_vpc.terra_vpc.id

   dynamic "ingress" {
      for_each = local.ingress_rules

      content {
         description = ingress.value.description
         from_port   = ingress.value.port
         to_port     = ingress.value.port
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
      }
   }

 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


   tags = {
      Name = "terra-sg"
   }
}

resource "aws_subnet" "subnet-1-public" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subnet-1-public"
  }
}

resource "aws_subnet" "subnet-2-private" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "subnet-2-public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "IGW-Terra"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-1"
  }
}

resource "aws_route_table_association" "rt-public-1-a" {
  subnet_id      = aws_subnet.subnet-1-public.id
  route_table_id = aws_route_table.rt-1.id
}

