terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61"
    }
    null = ">= 2.0"
  }
}

# terraform {
#   required_version = ">= 1.4.6"

#   required_providers {
#     aws  = ">= 2.0"
#     null = ">= 2.0"
#   }
# }
