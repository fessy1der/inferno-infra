locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment
  project_name = local.environment_vars.locals.project_name
  region       = local.region_vars.locals.aws_region

}

include {
  path = find_in_parent_folders()
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"
}

dependency "vpc" {
  config_path = "../../../shared/vpc"
}

dependency "app-sg" {
  config_path = "../ecs"
}




inputs = {
  name                = "RDS for inferno Service"
  description         = "Security group for RDS that allows app service to connect"
  egress_rules        = ["all-all"]
  vpc_id      = dependency.vpc.outputs.vpc_id



#  computed_ingress_with_source_security_group_id = [
#    {
#      rule                     = "postgres-tcp"
#      source_security_group_id = dependency.app-sg.outputs.security_group_id
#      to_port = 5432
#    }
#  ]
#  number_of_computed_ingress_with_source_security_group_id = 1
}



