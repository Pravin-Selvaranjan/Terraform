# Terraform
![1280px-Terraform_Logo svg](https://user-images.githubusercontent.com/110179866/189091692-2dab3e1c-7b81-4c30-a970-f54c9a758110.png)


- In its most basic form, Terraform is an application that converts configuration files known as HCL (Hashicorp Configuration Language) into real world infrastructure, usually in Cloud providers such as AWS, Azure or Google Cloud Platform.
- Infrastructure as Code (IaC) is a widespread terminology among DevOps professionals. It is the process of managing and provisioning the complete IT infrastructure (comprises both physical and virtual machines) using machine-readable definition files. It is a software engineering approach toward operations. It helps in automating the complete data center by using programming scripts.

## Benefits of Terraform?


- Does orchestration, not just configuration management
- Supports multiple providers such as AWS, Azure, GCP, DigitalOcean and many more
- Provide immutable infrastructure where configuration changes smoothly
- Uses easy to understand language, HCL (HashiCorp configuration language)
- Easily portable to any other provider
- Supports Client only architecture, so no need for additional configuration management on a server



## Steps to take in order to utilise Terraform

- 1. Install [Terraform](https://www.terraform.io/downloads)
- 2. Deploy a singler server, Terraform code is written in a language called HCL in files with the extension .tf. It is a declarative language, so your goal is to describe the infrastructure you want, and Terraform will figure out how to create it. Terraform can create infrastructure across a wide variety of platforms, or what it calls providers, including AWS, Azure, Google Cloud, DigitalOcean, and many others.
- 3. The first step to using Terraform is typically to configure the provider(s) you want to use. Create a file called main.tf and put the following code in it:

```
provider "aws" {
  region = "us-east-2"
}
```
- 4. Create a block of code to create the instance
```
# create a block of code to launch ec2-server
resource "aws_instance" "app_instance" {
  

# which resources do we want to create 
# using which ami
    ami = "ami-0b47105e3d7fc023e"

# instance type
    instance_type = "t2.micro"
# do we need it to have public ip

    associate_public_ip_address = true
# how to name your instance 
    tags = {
      Name = "eng122_pravin_terraform_app"
    }
}
```
- 5. Run `terraform plan` to check for syntax errors and if all is working correctly
- 6. Run `terraform apply` to apply and run the main.tf code
- 7. Use `key_name = "eng122_pravin_key1"` in order to specify the key pair to use so you can ssh into your machine

Main commands:
  init          Prepare your working directory for other commands 
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management