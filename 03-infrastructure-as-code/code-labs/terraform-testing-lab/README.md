# terraform-testing-lab

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.28.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.allow_web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Which OS to deploy: 'ubuntu' or 'amazon-linux' | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | n/a |
<!-- END_TF_DOCS -->
