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
  description = "Username of user associated with PAT. Needs admin:org scope"
}

variable "github_pat" {
  type = string
  description = "GitHub PAT with repo scope"
}

variable "org-name" {
  type = string
}

variable "runner_name" {
  type = string
}