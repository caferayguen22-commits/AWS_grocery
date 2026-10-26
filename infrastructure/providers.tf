terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  # Schutz: Terraform arbeitet nur im Masterschool-Konto, nie versehentlich in einem anderen
  allowed_account_ids = ["414239338791"]

  default_tags {
    tags = {
      Project   = "grocerymate"
      ManagedBy = "terraform"
    }
  }
}
