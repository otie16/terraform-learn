provider "aws" {
  region =  "us-east-1"
}

variable "cidr_blocks" {
  description = "cidr blocks & name tags for vpc and subnets"
#   type = list(string)
type = list(object({
  cidr_block = string
  name = string 
}))
}


resource "aws_vpc" "dev_vpc" {
#   cidr_block = var.cidr_blocks[0]
cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name: var.cidr_blocks[0].name
  }
}

resource "aws_subnet" "dev_subnet_1" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = var.cidr_blocks[1].cidr_block
    availability_zone = "us-east-1a"
    tags = {
      "Name": "subnet-1-dev" 
    }
}