terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "goosetunetv-terraform-state"
    key            = "application/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# Data sources for remote states
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "goosetunetv-terraform-state"
    key    = "network/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "security" {
  backend = "s3"
  config = {
    bucket = "goosetunetv-terraform-state"
    key    = "security/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"
  config = {
    bucket = "goosetunetv-terraform-state"
    key    = "database/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "terraform_remote_state" "platform" {
  backend = "s3"
  config = {
    bucket = "goosetunetv-terraform-state"
    key    = "platform/terraform.tfstate"
    region = "ap-northeast-1"
  }
}