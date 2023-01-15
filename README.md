# GitHub Self Hosted Runners Using AWS EC2

This project provides:
- A Packer image to build an AMI with Docker and the GitHub runner configuration
- Terraform modules to provision EC2 instances that configure and start a repo/org runner

# Potential Improvements

- [ ] ARM image/machine support
- [ ] AWS Network Firewall to only allow outbound traffic to [github domains](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners#communication-between-self-hosted-runners-and-github)
- [ ] CloudWatch for logging/metrics
- [ ] Auto de-register on destroy
- [ ] Runner groups for GitHub Enterprise