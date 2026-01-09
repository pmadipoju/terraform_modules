terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#################################
# Fetch Default VPC Automatically
#################################
data "aws_vpc" "prod" {
  filter {
    name   = "tag:Environment"
    values = ["prod"]
  }
}


#################################
# Security Group
#################################
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for Web Servers"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "web-sg"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

#################################
# Ingress Rules
#################################
resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["10.0.0.0/16"]   # Restrict SSH
  security_group_id = aws_security_group.web_sg.id
}

#################################
# Egress
#################################
resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}
