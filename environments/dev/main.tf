terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
  }

  backend "s3" {
    bucket   = "${var.infra_env}ttomczyk-s3-bucket"
    key      = "terraform/dev/terraform.tfstate"
    region   = var.main_region
  }

  required_version = ">= 1.2.0"
}
