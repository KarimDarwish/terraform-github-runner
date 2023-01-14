terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source = "hashicorp/http"
      version = "3.2.1"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}


module "runner-001" {
  source = "./modules/github-runner"

  runner_name = "gh-runner-001"

  github-username = var.github-username
  github-pat = var.github-pat

  repo-name = var.repo-name
  repo-owner = var.repo-owner
}

module "runner-002"  {
  source = "./modules/github-runner"

  runner_name = "gh-runner-002"

  github-username = var.github-username
  github-pat = var.github-pat

  repo-name = var.repo-name
  repo-owner = var.repo-owner
}

