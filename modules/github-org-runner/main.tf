locals {
  runner_token = jsondecode(data.http.github_token_request.response_body).token
  auth_format = "${var.github_username}:${var.github_pat}"
}

data "http" "github_token_request" {
  url = "https://api.github.com/orgs/${var.org_name}/actions/runners/registration-token"
  method = "POST"
  request_headers = {
    "Authorization" = "Basic ${base64encode(local.auth_format)}"
    "Accept" = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
  }

  lifecycle {
    postcondition {
      condition     = contains([201], self.status_code)
      error_message = "Could not get runner token for organization: ${var.org_name}. Verify your PAT and the org name are correct."
    }
  }
}

module "ec2-github-runner" {
  source = "../github-runner"

  github_pat = var.github_pat
  github_username = var.github_username
  runner_name = var.runner_name
  runner_token = local.runner_token

  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  root_block_device = var.root_block_device

  url = "https://github.com/${var.org_name}"
}