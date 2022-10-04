#----------------------------------------------------------
# ACS730 - Week 3 - Terraform 
#
#----------------------------------------------------------

#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Data block to retrieve the default VPC id
data "aws_vpc" "default" {
  default = true
}

# Reference subnet provisioned by 01-Networking 
resource "aws_instance" "my_amazon" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = lookup(var.instance_type, var.env)
  key_name               = aws_key_pair.sweta_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  lifecycle {
    create_before_destroy = true
  }

  tags =    {
      Name = "Assignment1-Amazon-Linux"
    }
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "sweta_key" {
  key_name   = "sweta_key"
  public_key = file("sweta_key.pub")
}

# Security Group
resource "aws_security_group" "my_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Http from everywhere"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Http from everywhere"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags ={
      Name = "Assignment1-sg"
    }
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.my_amazon.id
  vpc      = true
}

resource "aws_ecr_repository" "cat" {
  name                 = "catv2"
} 

resource "aws_ecr_repository" "dog" {
  name                 = "dogv2"
}