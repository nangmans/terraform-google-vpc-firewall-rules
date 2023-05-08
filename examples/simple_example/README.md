# Simple Example

This example illustrates how to use the `firewall-rule` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| config\_directories | List of paths to folders where firewall configs are stored in yaml format. Folder may include subfolders with configuration files. Files suffix must be `.yaml`. | `list(string)` | n/a | yes |
| log\_config | Log configuration. Possible values for `metadata` are `EXCLUDE_ALL_METADATA` and `INCLUDE_ALL_METADATA`. Set to `null` for disabling firewall logging. | <pre>object({<br>    metadata = string<br>  })</pre> | `null` | no |
| network | Name of the network this set of firewall rules applies to. | `string` | n/a | yes |
| project\_id | Project Id. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| egress\_allow\_rules | Egress rules with allow blocks. |
| egress\_deny\_rules | Egress rules with allow blocks. |
| ingress\_allow\_rules | Ingress rules with allow blocks. |
| ingress\_deny\_rules | Ingress rules with deny blocks. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
