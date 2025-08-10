#!/bin/bash
set -euo pipefail

# basic updates and ensure SSM agent present
if [ -x "$(command -v yum)" ]; then
  # Amazon Linux / RHEL family
  yum update -y
  yum install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
elif [ -x "$(command -v apt-get)" ]; then
  # Debian/Ubuntu
  apt-get update -y
  apt-get install -y snapd
  # On some Ubuntu versions the ssm agent is available via snap or deb; try snap
  if command -v snap >/dev/null 2>&1; then
    snap install amazon-ssm-agent --classic || true
    systemctl enable snap.amazon-ssm-agent.amazon-ssm-agent || true
    systemctl start snap.amazon-ssm-agent.amazon-ssm-agent || true
  fi
fi

hostnamectl set-hostname ${hostname}
