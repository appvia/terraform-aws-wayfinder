<!-- BEGIN_TF_DOCS -->
# Terraform Module:
This Terraform Module can be used to provision a cloud identity for wayfinder on aws

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | A Wayfinder instance ID | `string` | `""` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | A custom suffix for the created resources | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_key_id"></a> [access\_key\_id](#output\_access\_key\_id) | The ID of the created access key |
| <a name="output_iam_user_arn"></a> [iam\_user\_arn](#output\_iam\_user\_arn) | The ARN of the created IAM user |
| <a name="output_iam_user_name"></a> [iam\_user\_name](#output\_iam\_user\_name) | The name of the created IAM user |
| <a name="output_secret_access_key"></a> [secret\_access\_key](#output\_secret\_access\_key) | The value of the secret access key |
<!-- END_TF_DOCS -->