locals {
  runner_token = jsondecode(data.http.github_token_request.response_body).token
  repo_fqn = "${var.repo-owner}/${var.repo-name}"
  repo_url = "https://github.com/${local.repo_fqn}"
  repo_api_url = "https://api.github.com/repos/${local.repo_fqn}"
  auth_format = "${var.github-username}:${var.github-pat}"
}

data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["github-runner-amzn2-x86_64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "http" "github_token_request" {
  url = "${local.repo_api_url}/actions/runners/registration-token"
  method = "POST"
  request_headers = {
    "Authorization" = "Basic ${base64encode(local.auth_format)}"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
  }

  lifecycle {
    postcondition {
      condition     = contains([201], self.status_code)
      error_message = "Could not get runner token for repo: ${local.repo_fqn}. Verify your PAT and repo name are correct."
    }
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = "t3.micro"

  user_data = templatefile("${path.module}/templates/start-gh-runner-user-data.sh", {
    repo_url = "https://github.com/${var.repo-owner}/${var.repo-name}",
    runner_token = local.runner_token
    runner_name = var.runner_name
  })

  tags = {
    Name = var.runner_name
    ForRepo=local.repo_fqn
    Created-By = "Terraform"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}