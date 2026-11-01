terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "default"

}
