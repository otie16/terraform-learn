provider "aws" {
  region = "us-east-1"
}

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

# Query data from aws
# data "aws_ami" "latest-amazon-linux-image" {
#   most_recent = true
#   owners = ["amazon"]
  
# }

# output "aws_ami_id" {
#   value = data.aws_ami.latest-amazon-linux-image.id
# }

# Create ssh key pair
resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key-pair"
  public_key = file(var.public_key_path)
  }
# import {
#   to = aws_key_pair.ssh-key
#   id = "server-key-pair"
# }
output "ec2_public_ip" {
  value = aws_instance.myapp_server.public_ip
}

# Creating our instance
resource "aws_instance" "myapp_server" {
  ami = "ami-00a929b66ed6e0de6"
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp_subnet_1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  key_name = aws_key_pair.ssh-key.key_name
  user_data = <<EOF
                  #!/bin/bash
                  sudo yum update -y && sudo yum install
                  sudo apt update
                  sudo apt install docker.io -y
                  sudo usermod -aG docker jenkins
                  sudo usermod -aG docker ec2-user
                  sudo systemctl restart docker
                  sudo chmod 777 /var/run/docker.sock 
                  docker run -p 8080:80 nginx
                EOF
                
  user_data_replace_on_change = true # Destroy and recreate the instance when userdata script is modified
  
  associate_public_ip_address = true

  tags = {
    Name: "myapp-demo-server"
  }




}