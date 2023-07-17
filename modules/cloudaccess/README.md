<!-- BEGIN_TF_DOCS -->
# Terraform Module: Cloud Access for Wayfinder on AWS

This Terraform Module can be used to provision IAM Roles that Wayfinder assumes into, for creating resources within an AWS Account (VPC, EKS Cluster, Route53 DNS Zones, etc).

**Notes:**
* The IAM Role ARN (`var.wayfinder_iam_role_arn`) used by Wayfinder (via IAM Roles for Service Accounts) must be provided to update the IAM Role Trust Policy for any Roles created by this module.
* The `var.instance_id` is optional for reference to the Wayfinder instance, if you are using multiple Wayfinder instances in the same AWS account.
* The `var.workspace_id` is optional for reference to a Wayfinder workspace. This may be relevant if the same AWS Account is linked to multiple workspaces, and you want to attribute any Cloud actions to a specific workspace.

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module.

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:
1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_cluster_manager_role"></a> [create\_cluster\_manager\_role](#input\_create\_cluster\_manager\_role) | Whether to create the Cluster Manager IAM Role | `bool` | `true` | no |
| <a name="input_create_dns_zone_manager_role"></a> [create\_dns\_zone\_manager\_role](#input\_create\_dns\_zone\_manager\_role) | Whether to create the DNS Zone Manager IAM Role | `bool` | `true` | no |
| <a name="input_create_network_manager_role"></a> [create\_network\_manager\_role](#input\_create\_network\_manager\_role) | Whether to create the Network Manager IAM Role | `bool` | `true` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | A Wayfinder instance ID if roles are to be kept unique to an instance | `string` | `""` | no |
| <a name="input_wayfinder_iam_role_arn"></a> [wayfinder\_iam\_role\_arn](#input\_wayfinder\_iam\_role\_arn) | The ARN of Wayfinder's IAM role to allow in trust policies | `string` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | A Wayfinder workspace ID if Roles are to be kept unique to a workspace | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_manager_role_arn"></a> [cluster\_manager\_role\_arn](#output\_cluster\_manager\_role\_arn) | The ARN of the Cluster Manager IAM Role |
| <a name="output_cluster_manager_role_name"></a> [cluster\_manager\_role\_name](#output\_cluster\_manager\_role\_name) | The name of the Cluster Manager IAM Role |
| <a name="output_dns_zone_manager_role_arn"></a> [dns\_zone\_manager\_role\_arn](#output\_dns\_zone\_manager\_role\_arn) | The ARN of the DNS Zone Manager IAM Role |
| <a name="output_dns_zone_manager_role_name"></a> [dns\_zone\_manager\_role\_name](#output\_dns\_zone\_manager\_role\_name) | The name of the DNS Zone Manager IAM Role |
| <a name="output_network_manager_role_arn"></a> [network\_manager\_role\_arn](#output\_network\_manager\_role\_arn) | The ARN of the Network Manager IAM Role |
| <a name="output_network_manager_role_name"></a> [network\_manager\_role\_name](#output\_network\_manager\_role\_name) | The name of the Network Manager IAM Role |
<!-- END_TF_DOCS -->