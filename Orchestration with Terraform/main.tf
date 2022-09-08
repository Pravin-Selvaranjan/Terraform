

# who is the cloud provider 
# aws
provider "aws" {
    region = "eu-west-1"
}



# within the cloud which part of the world 
# we want to use eu-west-1

# initialise and download required packages
# terraform init


# create a block of code to launch ec2-server
resource "aws_instance" "app_instance" {
  

# which resources do we want to create 
# using which ami
    ami = "ami-0b47105e3d7fc023e"

# instance type
    instance_type = "t2.micro"
# do we need it to have public ip
    key_name = "eng122_pravin_key1"

    associate_public_ip_address = true
# how to name your instance 
    tags = {
      Name = "eng122_pravin_terraform_app"
    }
}

# find out how to attached your file.pem