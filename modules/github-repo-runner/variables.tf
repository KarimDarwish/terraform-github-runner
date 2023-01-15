variable "subnet_id" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "ec2_instance_type" {
  type = string
  default = "t3.micro"
}
variable "github_username" {
  type = string
}

variable "github_pat" {
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