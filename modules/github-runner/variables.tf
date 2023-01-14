
variable "ec2-instance-type" {
  type = string
  default = "t3.micro"
}
variable "github-username" {
  type = string
}

variable "github-pat" {
  type = string
  description = "GitHub PAT with repo scope"
}

variable "repo-owner" {
  type = string
}
variable "repo-name" {
  type = string
}

variable "runner_name" {
  type = string
}