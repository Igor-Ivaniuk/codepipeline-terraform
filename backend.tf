provider "aws" {
  region = "eu-west-1"
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
    bucket         = var.backend_bucket
    key            = "terraform.state"
    dynamodb_table = "terraform-state-table"
    region         = local.region
    encrypt        = true
  }
}
