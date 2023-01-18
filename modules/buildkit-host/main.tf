data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["buildkit-amzn2-amd64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = var.ec2_instance_type

#  vpc_security_group_ids = var.vpc_security_group_ids
#  subnet_id = var.subnet_id

  user_data = file("${path.module}/scripts/buildkit_user_data.sh")

  ebs_optimized = true

  tags = {
    Name = var.host_name
    ManagedBy = "terraform"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}