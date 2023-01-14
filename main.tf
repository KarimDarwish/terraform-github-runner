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

module "org-runner-001"  {
  source = "./modules/github-org-runner"

  runner_name = "gh-runner-001"
  org-name = var.org_name
  github_username = var.repo_owner
  github_pat = var.github_org_pat
}

module "repo-runner-001" {
  source = "./modules/github-repo-runner"

  runner_name = "gh-runner-001"

  github_username = var.github_username
  github_pat = var.github_pat

  repo-name = var.repo_name
  repo-owner = var.repo_owner
}
