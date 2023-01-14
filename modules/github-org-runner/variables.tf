
variable "ec2-instance-type" {
  type = string
  default = "t3.micro"
}

variable "github-username" {
  type = string
  description = "Username of user associated with PAT. Needs admin:org scope"
}

variable "github-pat" {
  type = string
  description = "GitHub PAT with repo scope"
}

variable "org-name" {
  type = string
}

variable "runner_name" {
  type = string
}