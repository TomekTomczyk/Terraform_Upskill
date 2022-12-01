terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
  }

  backend "s3" {
    bucket   = "ttomczyk-s3-bucket"
    key      = "terraform/terraform.tfstate"
    region   = "eu-west-1"
  }

  required_version = ">= 1.2.0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

provider "aws" {
  profile = "pgs-sandbox"
  region  = "eu-west-1"
}

resource "aws_vpc" "ttomczyk_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "ttomczyk-vpc"
  }
}

resource "aws_internet_gateway" "ttomczyk_aws_igw" {
  vpc_id = "aws_vpc.ttomczyk_vpc.id"
  
  tags = {
    Name = "ttomczyk-aws-igw"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = "aws_vpc.ttomczyk_vpc.id"
  cidr_block        = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "ttomczyk-tf-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = "aws_vpc.ttomczyk_vpc.id"
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "ttomczyk-tf-public-subnet2"
  }
}

resource "aws_route_table" "aws_route_table_public1" {
  vpc_id = "aws_vpc.ttomczyk_vpc.id"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.ttomczyk_aws_igw.id"
  }

  tags = {
    Name = "ttomczyk-aws-route-table-public1"
  }
}

resource "aws_route_table" "aws_route_table_public2" {
  vpc_id = "aws_vpc.ttomczyk_vpc.id"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.ttomczyk_aws_igw.id"
  }

  tags = {
    Name = "ttomczyk-aws-route-table-public2"
  }
}

resource "aws_route_table_association" "aws_route_table_association_public1" {
  subnet_id = "aws_subnet.public_subnet1.id"
  route_table_id = "aws_route_table.aws_route_table_public1.id"
}

resource "aws_route_table_association" "aws_route_table_association_public2" {
  subnet_id = "aws_subnet.public_subnet2.id"
  route_table_id = "aws_route_table.aws_route_table_public2.id"
}

resource "aws_network_interface" "aws_network_interface1" {
  subnet_id   = aws_subnet.public_subnet1.id
  private_ips = ["10.0.0.100"]

  tags = {
    Name = "ttomczyk_network_interface1"
  }
}

resource "aws_network_interface" "aws_network_interface2" {
  subnet_id   = aws_subnet.public_subnet2.id
  private_ips = ["10.0.0.200"]

  tags = {
    Name = "ttomczyk_network_interface2"
  }
}
