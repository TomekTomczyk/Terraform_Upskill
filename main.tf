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

resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  tags = {
    Name = "ttomczyk-aws-int-gw"
  }
}

resource "aws_eip" "aws_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.aws_eip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "ttomczyk-aws-nat-gw"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = "10.0.32.0/22"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "ttomczyk-tf-public-subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = "10.0.36.0/22"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "ttomczyk-tf-public-subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "ttomczyk-tf-private-subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.ttomczyk_vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "ttomczyk-tf-private-subnet2"
  }
}

resource "aws_route_table" "aws_route_table_public" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gateway.id
  }

  tags = {
    Name = "ttomczyk-aws-route-table-public"
  }
}

resource "aws_route_table" "aws_route_table_private" {
  vpc_id = aws_vpc.ttomczyk_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "ttomczyk-aws-route-table-private"
  }
}

resource "aws_route_table_association" "aws_route_table_association_public1" {
  subnet_id = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_public2" {
  subnet_id = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_private1" {
  subnet_id = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.aws_route_table_private.id
}

resource "aws_route_table_association" "aws_route_table_association_private2" {
  subnet_id = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.aws_route_table_private.id
}

resource "aws_instance" "aws_instance1" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ttomczyk_ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ttomczyk_aws_iam_instance_profile.name
  subnet_id              = aws_subnet.public_subnet1.id

  tags = {
    Name  = var.instance_name_1
    Owner = "ttomczyk"
  }
}

resource "aws_instance" "aws_instance2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ttomczyk_ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ttomczyk_aws_iam_instance_profile.name
  subnet_id              = aws_subnet.public_subnet2.id

  tags = {
    Name  = var.instance_name_2
    Owner = "ttomczyk"
  }
}

resource "aws_security_group" "ttomczyk_ec2_security_group" {
  vpc_id      = aws_vpc.ttomczyk_vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ttomczyk_ec2_security_group"
  }
}

resource "aws_iam_instance_profile" "ttomczyk_aws_iam_instance_profile" {
  name = "ttomczyk_aws_iam_instance_profile"
  role = aws_iam_role.ttomczyk_aws_iam_role.name
}

resource "aws_iam_role" "ttomczyk_aws_iam_role" {
  name               = "ttomczyk_aws_iam_role"
  assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Sid    = ""
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    })

  tags = {
    Name = "ttomczyk-aws-iam-role"
  }
}

resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
  role       = aws_iam_role.ttomczyk_aws_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}