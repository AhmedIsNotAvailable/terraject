terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS-Provider
provider "aws" {
  region = var.region
}

#============================> INIT VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "terra-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}


#------------> DECLARE SUBNETS

#can init subnets with vpc using 'module'
#   !______ But id conflicts with NAT Attachemnt

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
    Terraform   = "true"
    Environment = "dev"
  }
}


# ------------> Outputs for VPC init
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.aws_vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of subnet assigned to public internet IDs"
  value       = module.aws_vpc.public_subnets
}

#--------------> NAT init
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#---------------> NAT ATTACH
resource "aws_internet_gateway_attachment" "gw_attach" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.main.id
}

# <=================== VPC SETUP COMPLETE






