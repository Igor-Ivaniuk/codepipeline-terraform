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

terraform {
  backend "s3" {
      bucket = "iivaniuk-terraform-state-bucket"
      key = "terraform.state"
      dynamodb_table = "terraform-state-table"
      region = "eu-west-1"
      encrypt = true
  }
}