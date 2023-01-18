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

module "vpc" {
  source = "./modules/github-runner-vpc"
  subnet_availability_zone = "eu-central-1a"
}

module "buildkit-host-001" {
  source = "./modules/buildkit-host"
  host_name = "buildkit-host-001"
  ec2_instance_type = "t3.micro"

  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]
}

module "repo-runner-001" {
  source = "./modules/github-repo-runner"

  runner_name = "gh-runner-001"

  github_username = var.github_username
  github_pat = var.github_pat

  repo-name = var.repo_name
  repo-owner = var.repo_owner

  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]

  buildkit_host_ip = module.buildkit-host-001.private_ip

  depends_on = [module.vpc]
}