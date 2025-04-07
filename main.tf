provider "aws" {
  region = "us-east-1"
}

variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}

# Creating a VPC
resource "aws_vpc" "myapp_vpc" {
#   cidr_block = var.cidr_blocks[0]
cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

# Creating a subnet
resource "aws_subnet" "myapp_subnet_1" {
    vpc_id = aws_vpc.myapp_vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
      "Name": "${var.env_prefix}-subnet-1" 
    }
}

# Creating internet gateway
resource "aws_internet_gateway" "myapp-gateway" {
  vpc_id = aws_vpc.myapp_vpc.id
  tags = {
    Name: "${var.env_prefix}-igw"
  }
}

# configure the default route table
resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-gateway.id
  }
  tags = {
    Name: "${var.env_prefix}-main-rtb"
  }
} 

# Creating route table for vpc
# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.myapp_vpc.id

#   route {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = aws_internet_gateway.myapp-gateway.id
#   }

#   tags = {
#     Name: "${var.env_prefix}-rtb"
#   }
# }

# # setup route table and subnet association
# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id = aws_subnet.myapp_subnet_1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

# create a security group
resource "aws_security_group" "myapp-sg" {
  name = "myapp-nginx-sg"
  vpc_id = aws_vpc.myapp_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name: "${var.env_prefix}-sg"
  }
}