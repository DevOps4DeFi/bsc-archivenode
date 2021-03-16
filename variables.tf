## Note, to make things understandable, all code uses locals
## All variables should be mapped to locals in vars_to_locals.tf
## Other locals can go here too, or in-line with code when it makes sense
variable "sumo_id_ssm_path" {
  type        = string
  description = "The API Key for Sumo logic logging"
  default     = ""
}

variable "sumo_key_ssm_path" {
  type        = string
  description = "The API Key for Sumo logic logging"
  default     = ""
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

variable "vpc_id" {
  type        = string
  default     = null
  description = "The VPC to deploy into, if null use default vpc."
}

variable "datavolume_size" {
  type        = number
  default     = 1500
  description = "The amount of storage to allocate in gb for storage"
}

variable "ebs_snapshot_id" {
  type        = string
  default     = null
  description = "A snapshot datavolume to start with."
}

variable "instance_type" {
  type        = string
  default     = "c5a.2xlarge"
  description = "AWS instance type to use"
}
variable "public_lb_https_listener_arn" {
  type        = string
  description = "The arn to an https alb listener that will be used for load balancing public facing services"
}
variable "public_lb_name" {
  type        = string
  description = "The name of the public alb running the specified listener"
}
variable "public_lb_sg_id" {
  type        = string
  description = "The id of a security group that the public alb is in"
}
variable "private_lb_https_listener_arn" {
  type        = string
  description = "The arn to an https alb listener that will be used for load balancing private facing services"
}
variable "private_lb_name" {
  type        = string
  description = "The name of the private alb running the specified listener"
}
variable "private_lb_sg_id" {
  type        = string
  description = "The id of a security group that the private alb is in"
}

variable "disable_instance_termination" {
  default     = true
  description = "Set to false to allow the instance to be terminated, make sure you take a snapshot of your data volume first"
}
variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of public subnets in the vpc, if null use default vpc."
}

variable "tags" {
  type = map(string)
  default = {}
}