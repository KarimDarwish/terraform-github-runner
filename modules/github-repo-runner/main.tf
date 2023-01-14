locals {
  runner_token = jsondecode(data.http.github_token_request.response_body).token
  repo_fqn = "${var.repo-owner}/${var.repo-name}"
  repo_url = "https://github.com/${local.repo_fqn}"
  repo_api_url = "https://api.github.com/repos/${local.repo_fqn}"
  auth_format = "${var.github-username}:${var.github-pat}"
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

module "ec2-github-runner" {
  source = "../github-runner"

  github-pat = var.github-pat
  github-username = var.github-username
  runner_name = var.runner_name
  runner_token = local.runner_token
  url = "https://github.com/${var.repo-owner}/${var.repo-name}"
}