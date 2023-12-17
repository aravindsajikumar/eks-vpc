##################PROVIDER###########################
provider "aws" {
  region = "us-east-1"
}

###################STATE###########################
terraform {
 backend "s3" {
 encrypt        = true
 bucket         = "woooba-non-prod-terraform-state"
 dynamodb_table = "woooba-non-prod-terraform-state-lock"
 region         = "us-east-1"
 key            = "statefile/terraform.tfstate"
 }
}