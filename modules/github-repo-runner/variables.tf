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

variable "root_block_device" {
  type = object({
    volume_size           = string,
    volume_type           = string,
    encrypted             = bool,
    delete_on_termination = bool
  })

  default = {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
}

variable "buildkit_host_ip" {
  type = string
}