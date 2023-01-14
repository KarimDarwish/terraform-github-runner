data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["github-runner-amzn2-x86_64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = var.ec2_instance_type

  user_data = templatefile("${path.module}/templates/start-gh-runner-user-data.sh", {
    url = var.url,
    runner_token = var.runner_token
    runner_name = var.runner_name
  })

  tags = {
    Name = var.runner_name
    Created-By = "Terraform"
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}