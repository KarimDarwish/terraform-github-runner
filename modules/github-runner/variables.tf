variable "subnet_id" {
  type = string
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "github_username" {
  type = string
}

variable "github_pat" {
  type        = string
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

variable "root_block_device" {
  type = object({
    volume_size           = string,
    volume_type           = string,
    encrypted             = bool,
    delete_on_termination = bool
  })
}