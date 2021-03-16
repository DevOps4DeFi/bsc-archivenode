data "aws_caller_identity" "this" {
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

locals {
  vpc_cidr = data.aws_vpc.vpc.cidr_block
  vpc_id   = data.aws_vpc.vpc.id
}