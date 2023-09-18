provider "aws" {
  region = "eu-west-1"
  default_tags {
   tags = {
     Environment = "Test"
     Owner       = "TFProviders"
     Project     = "Test"
   }
 }
}


terraform {

# YOUR BACKEND CONFIGURATION
# If you want to enable S3 and DynamoDB as Backend, you must to add Permissions Policy on the CodeBuild Role 

# backend "s3" {

#     bucket = "terraform-example"
#     key = "terraform.state"
#     dynamodb_table = "terraform-example"
#     region = "eu-west-1"
#     encrypt = true
# }

}