
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

variable "runner_name" {
  type = string
}
variable "url" {
  type = string
}

variable "runner_token" {
  type = string
}