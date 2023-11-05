terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Region and IAM credentials
provider "aws" {
  region  = "us-west-2"
  access_key = "xxxxxx"
  secret_key = "xxxxxx"
}