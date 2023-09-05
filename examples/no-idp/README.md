<!-- BEGIN_TF_DOCS -->
# Example: No IDP (initialised with a localadmin user)

## Deployment

1. Create a DNS Zone in AWS Route53 and ensure the domain is delegated to the AWS nameservers.
2. Create an AWS Secrets Manager Secret with your Product License Key:
```sh
$ aws secretsmanager create-secret --name wayfinder-secrets

$ cat secret.json
{
  "licenseKey": "LICENSE-KEY"
}

$ aws secretsmanager put-secret-value --secret-id wf-secret-test --secret-string file://secret.json
```
3. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and update with your values.
4. Run `terraform init -upgrade -backend-config="bucket=BUCKET-NAME" -backend-config="key=STATE-FILE.tfstate" -backend-config="encrypt=true" -backend-config="dynamodb_table=TABLE-NAME" -backend-config="region=AWS-REGION"`
5. Run `terraform apply`

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to deploy into | `list(string)` | n/a | yes |
| <a name="input_aws_secretsmanager_name"></a> [aws\_secretsmanager\_name](#input\_aws\_secretsmanager\_name) | The name of the AWS Secrets Manager secret to fetch, which contains IDP configuration | `string` | `"wayfinder-secrets"` | no |
| <a name="input_clusterissuer_email"></a> [clusterissuer\_email](#input\_clusterissuer\_email) | The email address to use for the cert-manager cluster issuer | `string` | n/a | yes |
| <a name="input_disable_internet_access"></a> [disable\_internet\_access](#input\_disable\_internet\_access) | Whether to disable internet access for EKS and the Wayfinder ingress controller | `bool` | `false` | no |
| <a name="input_dns_zone_name"></a> [dns\_zone\_name](#input\_dns\_zone\_name) | The local DNS zone to use (e.g. wayfinder.example.com) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name we are provisioning | `string` | `"production"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources | `map(any)` | `{}` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the Wayfinder VPC | `string` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | List of private subnets in the Wayfinder VPC | `list(string)` | n/a | yes |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | List of public subnets in the Wayfinder VPC | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the Wayfinder EKS cluster |
| <a name="output_wayfinder_admin_password"></a> [wayfinder\_admin\_password](#output\_wayfinder\_admin\_password) | The password for the Wayfinder local admin user |
| <a name="output_wayfinder_admin_username"></a> [wayfinder\_admin\_username](#output\_wayfinder\_admin\_username) | The username for the Wayfinder local admin user |
| <a name="output_wayfinder_api_url"></a> [wayfinder\_api\_url](#output\_wayfinder\_api\_url) | The URL for the Wayfinder API |
| <a name="output_wayfinder_ui_url"></a> [wayfinder\_ui\_url](#output\_wayfinder\_ui\_url) | The URL for the Wayfinder UI |
<!-- END_TF_DOCS -->