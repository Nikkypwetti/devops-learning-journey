# HCL Syntax Cheatsheet

## Resource Blocks:

resource "provider_resource" "name" {
  argument = value
  nested_block {
    nested_argument = value
  }
}

## Data Sources:

data "provider_data" "name" {
  filter {
    name   = "filter_name"
    values = ["value1", "value2"]
  }
}

## Common Arguments:

- strings: "value"
- numbers: 42, 3.14
- booleans: true, false
- lists: ["item1", "item2"]
- maps: { key = "value" }

## Interpolation:

${resource.type.name.attribute}
${var.variable_name}
${data.source.name.attribute}

🔗 **Additional Resources**

- [Terraform Configuration Language](https://developer.hashicorp.com/terraform/language)
- [AWS EC2 Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Security Groups in Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)