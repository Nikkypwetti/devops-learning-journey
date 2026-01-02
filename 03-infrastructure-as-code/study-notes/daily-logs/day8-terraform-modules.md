# Day 4: [Terraform Modules]

What I Learned

    Concept 1:

        Understanding Modules

        A module is a container for multiple resources that are used together. Every Terraform configuration has at least one module, known as the root module, which consists of the resources defined in the .tf files in your main working directory.

    Concept 2:

        Encapsulation and Reusability

        Modules allow you to group related resources into a single logical unit. Instead of writing the same complex code for a VPC or a Web Server multiple times, you write it once in a module and call it whenever needed with different parameters.

    Concept 3:

        Module Sources

        You can source modules from different locations using the source argument. Common sources include local paths (e.g., ./modules/my-app), the Terraform Registry (pre-built community modules), GitHub, or Bitbucket.

    Concept 4:

        Input Variables and Outputs

        Modules act like functions:

            Inputs: Define variable blocks in the child module to allow the parent module to pass in values.

            Outputs: Define output blocks in the child module to pass information (like an IP address or ID) back to the parent module.

    Concept 5:

        Child vs. Root Modules

        When a configuration calls another module, the called module is referred to as a child module. The directory where you run terraform apply is always the root module. You can nest modules, but keeping the hierarchy shallow is a best practice.

    Concept 6:

        Module Versioning

        When using remote modules (like from the Registry), it is critical to specify a version. This prevents your infrastructure from breaking if the module author releases an update that includes breaking changes.

Code Practice
Terraform
# Directory of module 
├── LICENSE
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf

# --- Root Module (main.tf) ---

# Calling a local module for networking
module "vpc" {
  source      = "./modules/aws-network"
  vpc_cidr    = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Calling a Registry module for an EC2 instance
module "web_server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name           = "web-app-${terraform.workspace}"
  instance_type  = "t2.micro"
  
  # Using an output from the 'vpc' module
  subnet_id      = module.vpc.public_subnet_ids[0] 
}

# --- Child Module (modules/aws-network/variables.tf) ---

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# --- Child Module (modules/aws-network/outputs.tf) ---

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

Commands Used
Bash

# Downloads and installs modules defined in your configuration
terraform init

# Updates modules to the latest allowed version
terraform get -update

# List the module tree
terraform state list # Shows resources including their module path

ssh-keygen -t rsa -b 4096 -f my-key - use to create public and private key so that terraform can create my key_pair for me

Challenges

Problem: Trying to access a resource property inside a module from the root module directly. Solution: Realized that resources inside a module are encapsulated. I had to define an output block inside the child module to "export" that specific value to the root.
Resources

Video Tutorial
Video: [https://www.youtube.com/watch?v=7xngnjfIlK4](https://www.youtube.com/watch?v=7xngnjfIlK4) (12 mins)

    Video Notes: Modules help organize and reuse Terraform configurations. Root module is the main directory, child modules are reusable components. Module blocks call other modules with source parameter. Outputs from modules become available to parent. Version constraints can be specified.

Documentation
Reading: [https://developer.hashicorp.com/terraform/language/modules](https://developer.hashicorp.com/terraform/language/modules)

    Reading Summary: Modules are containers for multiple resources used together. Can be sourced locally, from Terraform Registry, GitHub, or HTTP URLs. Module composition allows building complex infrastructure. Best practices: use descriptive names, document inputs/outputs, version modules.

    Practice Completed: Created modules/ec2-instance with variables for AMI, instance_type, tags. Used in main.tf with module "web_server". Tested with terraform init, plan, apply.

Tomorrow's Plan

Topic 1: Terraform Module Registry
