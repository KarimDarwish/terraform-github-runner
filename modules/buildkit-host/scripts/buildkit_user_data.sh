#!/bin/bash -e

exec > >(tee /var/log/user-data.log | logger -t user-data -s 2>/dev/console) 2>&1

sudo ./opt/buildkit/bin/buildkitd --addr tcp://0.0.0.0:8082