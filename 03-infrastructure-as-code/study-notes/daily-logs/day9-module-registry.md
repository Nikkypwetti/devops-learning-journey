### Day 9: Terraform Module Registry

        Video Notes: Terraform Registry (registry.terraform.io) has community and verified modules. Search for AWS VPC module. Use with source = "terraform-aws-modules/vpc/aws". Specify version with version = "~> 3.0". Check module documentation for required inputs.

    Reading Summary: Registry hosts modules and providers. Public registry free, private registry in Terraform Cloud/Enterprise. Module namespacing: <organization>/<provider>/<name>. Versioning follows semantic versioning. Publishing requires GitHub repository with proper structure.

    Practice Completed: Used AWS VPC module from registry to create VPC with subnets. Created personal module in GitHub, added main.tf, variables.tf, outputs.tf. Tagged with v1.0.0.

    Tomorrow's Plan

Topic 1: Terraform State Management (Locking & Backends)
