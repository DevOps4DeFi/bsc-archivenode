## Note, to make things understandable, all code uses locals
## All variables should be mapped to locals in vars_to_locals.tf
## Other locals can go here too, or in-line with code when it makes sense
variable "ethnode_url_ssm_parameter_name" {
  type        = string
  description = "the name of an ssm parameter that holds the URL of the ethnode we will use"
}

variable "app_name" {
  type        = string
  description = "The name of the application that will be used for tagging."
  default     = "bsc-archive-node"
}
variable "aws_keypair_name" {
  type        = string
  description = "The name of the ssh keypair to use in order to allow access."
}
variable "route53_root_fqdn" {
  type        = string
  description = "Root route53 domain name that we should build records on top of."
}
variable "region" {
  type        = string
  description = "The aws region to deploy into."
}
variable "public_subnet_ids" {
  type        = list(string)
  default     = null
  description = "A list of public subnets in the vpc, if null use default vpc."
}
variable "vpc_id" {
  type        = string
  default     = null
  description = "The VPC to deploy into, if null use default vpc."
}



