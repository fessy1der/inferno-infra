locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  # Extract out common variables for reuse
  env          = local.environment_vars.locals.environment
  project_name = local.environment_vars.locals.project_name
  region       = local.region_vars.locals.aws_region

}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.

include {
  path = find_in_parent_folders()


}


terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-security-group"
}

dependency "vpc" {
  config_path = "../../../shared/vpc"
}

dependency "alb-inferno" {
  config_path = "../alb"
}


inputs = {
  name                = "inferno service"
  description         = "Security group for inferno service (ECS)"
  vpc_id      = dependency.vpc.outputs.vpc_id
  egress_rules        = ["all-all"]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = dependency.alb-inferno.outputs.security_group_id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = dependency.alb-inferno.outputs.security_group_id
    },
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = 6
      description              = "Application port (required for Healh check)"
      source_security_group_id = dependency.alb-inferno.outputs.security_group_id
    },

  ]
  number_of_computed_ingress_with_source_security_group_id = 3
}