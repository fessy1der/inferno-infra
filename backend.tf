# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "inferno-terragrunt-terraform-state-dev-eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "eu-central-1"
  }
}