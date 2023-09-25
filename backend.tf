provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = "Test"
      Owner       = "TFProviders"
      Project     = "TestProject"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

terraform {
  backend "s3" {
    bucket         = "iivaniuk-terraform-state-bucket" # Hardcoded until Terraform starts supporting 
    key            = "terraform.state"                 # variables in backend config block
    dynamodb_table = "terraform-state-table"           # see: https://github.com/hashicorp/terraform/issues/13022
    region         = "eu-west-1"                       #
    encrypt        = true
  }
}
