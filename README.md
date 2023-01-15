# GitHub Self Hosted Runners in AWS

This project provides:
- A Packer image to build an AMI with Docker and the GitHub runner configuration
- Terraform modules to provision EC2 instances that configure and start a repo/org runner

## AWS Architecture

<img width="659" alt="image" src="https://user-images.githubusercontent.com/18162254/212567358-b6c9708e-29a2-4f8c-82db-5cd24ddf227a.png">

- Only egress traffic on port 443 is allowed
- Ingress traffic is disabled

## Terraform

### Prerequisite

- Make sure you built the AMI using `packer build` before running Terraform. Alternatively, specify another AMI by exposing a variable.

### Considerations

- The PAT will not be stored/used on the EC2 machines, they will just be used to request short-lived (60min) runner tokens using Terraform to register the runners
- The registration will be done using a `user_data` script on the EC2 instances which is why the Terraform creation will not wait for the registration of the runner to be complete
- Currently, runners are not de-registered on GitHub when they are destroyed

### VPC

```
module "vpc" {
    source = "./modules/github-runner-vpc"
    subnet_availability_zone = "eu-central-1a"
}
```

will create the AWS VPC and the needed subnets/gateways without creating any runners.

You can also provide your own subnet/security group to be used by the EC2 instances instead.

### Repo Level Runner

This will create a new EC2 instance and add is as a runner to the provided repository.

The PAT needs `Read/Write access to actions` (fine-grained tokens)

```
module "repo-runner-001" {
  source = "./modules/github-repo-runner"

  runner_name = "gh-runner-001"

  github_username = var.github_username
  github_pat = var.github_pat #needs the "repo" scope

  repo-name = "terraform-github-runner"
  repo-owner = "KarimDarwish"

  ec2_instance_type = "t3.micro"
  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]
  
  root_block_device = {
    volume_size           = 120
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  
  depends_on = [module.vpc]
}
```

### Org Level Runner

This will create a new EC2 instance of the provided type and add it as an organization level runner to your GitHub org.

The PAT needs the `admin:org` scope to be able to add the runner.

```
module "org-runner-001" {
  source = "./modules/github-org-runner"

  runner_name = "gh-runner-001"

  github_pat = var.github_org_pat
  github_username = var.github_username

  org_name = "KarimDarwishOrg"

  ec2_instance_type = "t3.micro"
  subnet_id = module.vpc.subnet_id
  vpc_security_group_ids = [module.vpc.security_group_id]
  
  root_block_device = {
    volume_size           = 120
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  
  depends_on = [module.vpc]
}
```


# Potential Improvements

- [ ] ARM image/machine support
- [ ] AWS Network Firewall to only allow outbound traffic to [github domains](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners#communication-between-self-hosted-runners-and-github)
- [ ] CloudWatch for logging/metrics
- [ ] Auto de-register on destroy
- [ ] Runner groups for GitHub Enterprise
