terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "goosetunetv-terraform-state"
    key            = "security/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
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