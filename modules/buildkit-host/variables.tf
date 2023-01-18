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

variable "host_name" {
  type = string
}