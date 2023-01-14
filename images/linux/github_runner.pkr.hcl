packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "githubrunner" {
  ami_name      = "github-runner-amzn2-x86_64-${formatdate("YYYYMMDDhhmm", timestamp())}"
  instance_type = "t2.micro"
  region        = "eu-central-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.*-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"

  launch_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = "8"
    volume_type           = "gp3"
  }
}

build {
  name = "githubactions-runner"
  sources = [
    "source.amazon-ebs.githubrunner"
  ]
  provisioner "shell" {
    environment_vars = []
    inline = concat([
      "sudo yum update -y",
      "sudo yum install -y amazon-cloudwatch-agent curl jq git",
      "sudo amazon-linux-extras install docker",
      "sudo systemctl enable docker.service",
      "sudo systemctl enable containerd.service",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
    ])
  }

  provisioner "file" {
    content = file("../scripts/install-gh-runner.sh")
    destination = "/tmp/install-gh-runner.sh"
  }

  provisioner "shell" {
    environment_vars = []
    inline = [
      "sudo chmod +x /tmp/install-gh-runner.sh",
      "sudo /tmp/install-gh-runner.sh"
    ]
  }
}
