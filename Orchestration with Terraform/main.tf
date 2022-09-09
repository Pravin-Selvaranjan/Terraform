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
    vpc_id = aws_vpc.pravin_vpc.id   # connecting the to the vpc made in "main" resource
    cidr_block = var.pub_cidr_block.id

    tags = {
      "Name" = "eng122-pravin-vpc-public"
    }
}

# private subnet
resource "aws_subnet" "pravin_private" {
    vpc_id = aws_vpc.pravin_vpc.id   # can also just assign the id of the chosen vpc
    cidr_block = "10.0.15.0/24"

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

# ec2
resource "aws_instance" "eng122_pravin_app_terraform" {
    ami = "ami-0c505a1529b8253e8"

    instance_type = "t2.micro"

    associate_public_ip_address = true

    subnet_id = aws_subnet.pravin_public.id

    tags = {
      "Name" = "eng122_pravin_app_terraform"
    }

    key_name = "eng122_pravin_key1"

}