#!/bin/bash -e

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

sudo -su ec2-user ./opt/actions-runner/config.sh --unattended --url ${url} --token ${runner_token} --name ${runner_name} --replace
cd /opt/actions-runner
./svc.sh install
./svc.sh start