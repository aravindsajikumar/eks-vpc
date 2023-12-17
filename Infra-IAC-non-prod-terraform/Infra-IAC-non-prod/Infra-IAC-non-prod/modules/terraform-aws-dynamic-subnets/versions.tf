terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.61"
    }
    template = "~> 2.0"
    local    = "~> 1.2"
    null     = "~> 2.0"
  }
}

