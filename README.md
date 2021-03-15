# BSC acrhive node on EC2
### Using terraform infrastructure-as-code

Builds a BSC fullnode via userdata script and sends logging to sumo logic if a key is provided.

This is based on the DevOps4DeFi terraform-baseline.

The node is run on private subnets and jsonrpc access is provided over https via a load balancer external to the module.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_name | The name of the application that will be used for tagging. | `string` | `"bsc-archive-node"` | no |
| aws\_keypair\_name | The name of the ssh keypair to use in order to allow access. | `string` | n/a | yes |
| datavolume\_size | The amount of storage to allocate in gb for storage | `number` | `1500` | no |
| disable\_instance\_termination | Set to false to allow the instance to be terminated, make sure you take a snapshot of your data volume first | `bool` | `true` | no |
| ebs\_snapshot\_id | A snapshot datavolume to start with. | `string` | `null` | no |
| instance\_type | AWS instance type to use | `string` | `"c5a.2xlarge"` | no |
| private\_lb\_https\_listener\_arn | The arn to an https alb listener that will be used for load balancing private facing services | `string` | n/a | yes |
| private\_lb\_name | The name of the private alb running the specified listener | `string` | n/a | yes |
| private\_lb\_sg\_id | The id of a security group that the private alb is in | `string` | n/a | yes |
| private\_subnet\_ids | A list of public subnets in the vpc, if null use default vpc. | `list(string)` | n/a | yes |
| public\_lb\_https\_listener\_arn | The arn to an https alb listener that will be used for load balancing public facing services | `string` | n/a | yes |
| public\_lb\_name | The name of the public alb running the specified listener | `string` | n/a | yes |
| public\_lb\_sg\_id | The id of a security group that the public alb is in | `string` | n/a | yes |
| region | The aws region to deploy into. | `string` | n/a | yes |
| route53\_root\_fqdn | Root route53 domain name that we should build records on top of. | `string` | n/a | yes |
| sumo\_api\_key\_ssm\_path | The API Key for Sumo logic logging | `string` | `""` | no |
| vpc\_id | The VPC to deploy into, if null use default vpc. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_url | The base url to hit to access json-rpc |

