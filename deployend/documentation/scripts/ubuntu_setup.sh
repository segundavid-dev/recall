#!/bin/bash

set -e

echo "-----Updating package list"
sudo apt update

echo "-----Installing dependencies"
sudo apt install -y \
    software-properties-common \
    gnupg \
    lsb-release \
    curl \
    unzip \
    git \
    python3

echo "-----Installing Terraform"

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install -y terraform

echo "-----Installing AWS CLI v2"

cd /tmp

curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o awscliv2.zip

unzip -q awscliv2.zip

sudo ./aws/install --update

rm -rf aws awscliv2.zip

echo "-----Installing Ansible"

sudo apt install -y ansible

echo
echo "========== Installed Versions =========="

printf "Python:      "
python3 --version

printf "Git:         "
git --version

printf "Terraform:   "
terraform version | head -n 1

printf "AWS CLI:     "
aws --version

printf "Ansible:     "
ansible --version | head -n 1

echo
echo "Installation completed successfully."