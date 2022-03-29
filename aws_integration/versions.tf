terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "2.41.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
  required_version = "1.1.6"
}

provider "newrelic" {
  account_id = var.account_id
  api_key    = var.api_key
  region     = "US"
}

provider "aws" {
  region = "ap-northeast-1"
}
