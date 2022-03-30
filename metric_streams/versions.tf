terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
  required_version = "1.1.6"
}

provider "aws" {
  # Region の設定は作成する Region にあわせて作成してください。
  region = "ap-northeast-1"
}
