locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment



  region   = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()


}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {

name       = "inferno-${local.env}"
vpc_name   = "inferno-Main-${local.env}"
igw_name   = "inferno-IGW-Main-${local.env}"
create_vpc = true
create_igw = true
enable_nat_gateway = true
single_nat_gateway = true
one_nat_gateway_per_az = false



cidr = "192.168.0.0/16"
azs      = ["${local.region}a", "${local.region}b"]

public_subnets  = ["192.168.16.0/20", "192.168.32.0/20"]
private_subnets = ["192.168.48.0/20", "192.168.64.0/20"]
database_subnets    = ["192.168.80.0/20", "192.168.96.0/20"]
elasticache_subnets = ["192.168.112.0/20", "192.168.128.0/20"]

enable_dns_hostnames = false
map_public_ip_on_launch = true

enable_flow_log                                 = true
create_flow_log_cloudwatch_log_group            = true
create_flow_log_cloudwatch_iam_role             = true
flow_log_cloudwatch_log_group_retention_in_days = 7
}