provider "aws" {
  region = var.region
}

locals {
  public_cidr_block  = cidrsubnet(var.cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(var.cidr_block, 1, 1)
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.1"

  cidr_block = var.cidr_block

  context = module.this.context
}

module "public_subnets" {
  source = "../../"

  enabled             = var.enabled
  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = var.nat_gateway_enabled
  max_subnets         = length(var.availability_zones)

  context = module.this.context
}

module "private_subnets" {
  source = "../../"

  enabled            = var.enabled
  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_cidr_block
  type               = "private"
  max_subnets        = length(var.availability_zones)

  # Map of AZ names to NAT Gateway IDs that was created in "public_subnets" module
  az_ngw_ids = module.public_subnets.az_ngw_ids

  context = module.this.context
}

