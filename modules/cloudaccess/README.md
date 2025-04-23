# Terraform Module: Cloud Access for Wayfinder on AWS

This Terraform Module can be used to provision IAM Roles that Wayfinder assumes into, for creating resources within an AWS Account (VPC, EKS Cluster, Route53 DNS Zones, etc).

**Notes:**

- You must provide either:
  - The IAM Role ARN (`var.wayfinder_identity_aws_role_arn`) used by Wayfinder (via IAM Roles for Service Accounts) if you are running Wayfinder on AWS using IRSA, or using a credential-backed AWS IAM user.
  - The GCP service account email address and ID (`var.wayfinder_identity_gcp_service_account` and `var.wayfinder_identity_gcp_service_account_id`) used by Wayfinder (via GCP Workload Identity) if you are running Wayfinder on GCP.
  - The Azure managed identity client ID and tenant ID (`var.wayfinder_identity_azure_client_id` and `var.wayfinder_identity_azure_tenant_id`) used by Wayfinder (via AzureAD Workload Identity) if you are running Wayfinder on Azure.
- `var.resource_suffix` is an optional suffix to use on created objects. We recommend using workspace key + stage if you wish to have multiple workspaces sharing the same AWS account, allowing independent roles to be provisioned for each.

## Deployment

Please see the [examples](./examples) directory to see how to deploy this module.

## Updating Docs

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.62 |
| <a name="provider_http"></a> [http](#provider\_http) | >= 3.4 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.4 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_cloud_info"></a> [enable\_cloud\_info](#input\_enable\_cloud\_info) | Whether to create the Cloud Info IAM Role | `bool` | `false` | no |
| <a name="input_enable_cloud_resource_provisioning"></a> [enable\_cloud\_resource\_provisioning](#input\_enable\_cloud\_resource\_provisioning) | Whether to create the Cloud Resource Provisioning IAM Role | `bool` | `false` | no |
| <a name="input_enable_cluster_manager"></a> [enable\_cluster\_manager](#input\_enable\_cluster\_manager) | Whether to create the Cluster Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_dns_zone_manager"></a> [enable\_dns\_zone\_manager](#input\_enable\_dns\_zone\_manager) | Whether to create the DNS Zone Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_network_manager"></a> [enable\_network\_manager](#input\_enable\_network\_manager) | Whether to create the Network Manager IAM Role | `bool` | `false` | no |
| <a name="input_enable_peering_acceptor"></a> [enable\_peering\_acceptor](#input\_enable\_peering\_acceptor) | Whether to create the Peering Acceptor IAM Role | `bool` | `false` | no |
| <a name="input_from_aws"></a> [from\_aws](#input\_from\_aws) | Whether Wayfinder is running on AWS. | `bool` | `true` | no |
| <a name="input_from_azure"></a> [from\_azure](#input\_from\_azure) | Whether Wayfinder is running on Azure. | `bool` | `false` | no |
| <a name="input_from_gcp"></a> [from\_gcp](#input\_from\_gcp) | Whether Wayfinder is running on GCP. | `bool` | `false` | no |
| <a name="input_provision_oidc_trust"></a> [provision\_oidc\_trust](#input\_provision\_oidc\_trust) | Provisions an AWS OIDC Provider reference for Azure tenant ID. Set to false if you are managing OIDC provider trusts elsewhere. | `bool` | `true` | no |
| <a name="input_resource_suffix"></a> [resource\_suffix](#input\_resource\_suffix) | Suffix to apply to all generated resources. We recommend using workspace key + stage. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources created. | `map(string)` | `{}` | no |
| <a name="input_wayfinder_identity_aws_role_arn"></a> [wayfinder\_identity\_aws\_role\_arn](#input\_wayfinder\_identity\_aws\_role\_arn) | ARN of Wayfinder's identity to give access to. Populate when Wayfinder is running on AWS with IRSA, or with the user ARN when using a credential-based AWS identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_client_id"></a> [wayfinder\_identity\_azure\_client\_id](#input\_wayfinder\_identity\_azure\_client\_id) | Client ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_azure_tenant_id"></a> [wayfinder\_identity\_azure\_tenant\_id](#input\_wayfinder\_identity\_azure\_tenant\_id) | Tenant ID of Wayfinder's Azure AD managed identity to give access to. Populate when Wayfinder is running on Azure with AzureAD Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account"></a> [wayfinder\_identity\_gcp\_service\_account](#input\_wayfinder\_identity\_gcp\_service\_account) | Email address of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |
| <a name="input_wayfinder_identity_gcp_service_account_id"></a> [wayfinder\_identity\_gcp\_service\_account\_id](#input\_wayfinder\_identity\_gcp\_service\_account\_id) | Numerical ID  of Wayfinder's GCP service account to give access to. Populate when Wayfinder is running on GCP with Workload Identity. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloud_info_role_arns"></a> [cloud\_info\_role\_arns](#output\_cloud\_info\_role\_arns) | ARNs of Cloud Info IAM role to use for the CloudInfo spec.permissions[].awsRole in your CloudAccessConfig |
| <a name="output_cloud_resource_provisioning_role_arn"></a> [cloud\_resource\_provisioning\_role\_arn](#output\_cloud\_resource\_provisioning\_role\_arn) | ARNs of Cloud Resource IAM role to use for CloudResourceProvisioning spec.permission[].awsRole in your CloudAccessConfig |
| <a name="output_cluster_manager_role_arns"></a> [cluster\_manager\_role\_arns](#output\_cluster\_manager\_role\_arns) | ARNs of Cluster Manager IAM role to use for the ClusterManager spec.permissions[].awsRole in your CloudAccessConfig |
| <a name="output_dns_zone_manager_role_arns"></a> [dns\_zone\_manager\_role\_arns](#output\_dns\_zone\_manager\_role\_arns) | ARNs of DNS Zone Manager IAM role to use for the DNSZoneManager spec.permissions[].awsRole in your CloudAccessConfig |
| <a name="output_network_manager_role_arns"></a> [network\_manager\_role\_arns](#output\_network\_manager\_role\_arns) | ARNs of Network Manager IAM role to use for the NetworkManager spec.permissions[].awsRole in your CloudAccessConfig |
| <a name="output_peering_acceptor_role_arn"></a> [peering\_acceptor\_role\_arn](#output\_peering\_acceptor\_role\_arn) | ARN of Peering Acceptor IAM role to use as spec.permissions[].awsRole in your cloud access config |
<!-- END_TF_DOCS -->

