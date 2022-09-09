# what service and region
provider "aws" {
    region = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "pravin_vpc" {
    cidr_block = var.vpc_cidr_block

    tags = {
      "Name" = "eng122-pravin-vpc"
    }
}

# public subnet
resource "aws_subnet" "pravin_public" {
    vpc_id = aws_vpc.pravin_vpc.id   
    cidr_block = var.pub_cidr_block

    tags = {
      "Name" = "eng122-pravin-vpc-public"
    }
}

# private subnet
resource "aws_subnet" "pravin_private" {
    vpc_id = aws_vpc.pravin_vpc.id   
    cidr_block = var.priv_cidr_block

    tags = {
      "Name" = "eng122-pravin-vpc-private"
    }  
}

# ig
resource "aws_internet_gateway" "pravin_ig" {
    vpc_id = aws_vpc.pravin_vpc.id

    tags = {
        "Name" = "eng122-pravin-ig"
    }  
}

# route table
resource "aws_route_table" "pravin_public_route" {
    vpc_id = aws_vpc.pravin_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.pravin_ig.id
    }  

    tags = {
      "Name" = "eng122-pravin-public-route"
    }
}

# association
resource "aws_route_table_association" "pravin_connect_route_to_public" {
    subnet_id = aws_subnet.pravin_public.id
    route_table_id = aws_route_table.pravin_public_route.id  
}


# Security Groups
 resource "aws_security_group" "eng122_pravin_terraform_app_sg"  {
  name = "eng122_pravin_terraform_app_sg"
  description = "eng122_pravin_terraform_app_sg"
  vpc_id = aws_vpc.pravin_vpc.id # attaching the SG with your own VPC

# Inbound rules
  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]   
  }

# ssh access 
  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }

# allow port 3000

ingress {
    from_port       = "3000"
    to_port         = "3000"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]  
  }

# Outbound rules
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # allow all
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eng122_pravin_terraform_app_sg"
  }
}

# ec2
resource "aws_instance" "eng122_pravin_app_terraform" {
    ami = var.pravin_app_ami

    instance_type = "t2.micro"

    associate_public_ip_address = true

    subnet_id = aws_subnet.pravin_public.id

    vpc_security_group_ids = ["${aws_security_group.eng122_pravin_terraform_app_sg.id}"]

    tags = {
      "Name" = "eng122_pravin_app_terraform"
    }

    key_name = var.pravin_sparta_key

}