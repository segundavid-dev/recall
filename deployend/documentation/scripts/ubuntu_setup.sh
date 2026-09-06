#!/bin/bash

# Ubuntu 22.04 - Latest version (26.04)
# Recommended to run not as a UserData or One time server provisioning
# Exit immediately if any command exits with a non-zero status
set -e

# Update local package index to fetch latest package lists
echo "-----Updating package list"
sudo apt update

# Install baseline development tools, utilities, and Python 3
echo "-----Installing dependencies"
sudo apt install -y \
    software-properties-common \
    gnupg \
    lsb-release \
    curl \
    unzip \
    git \
    python3
    
# Download and configure the NodeSource repository setup script for Node.js 20 LTS
echo "-----Installing Nodejs & PNPM"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Install Node.js runtime and npm package manager
sudo apt install -y nodejs

# Install the pnpm package manager globally across the system
sudo npm install -g pnpm

# Configure HashiCorp repository keys and source list for Terraform
echo "-----Installing Terraform"

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com \
$(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Refresh package index with HashiCorp repo and install Terraform
sudo apt update
sudo apt install -y terraform

# Download, extract, and install the official AWS CLI v2 binary in a temporary directory
echo "-----Installing AWS CLI v2"

cd /tmp

curl -sS "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
-o awscliv2.zip

unzip -q awscliv2.zip

sudo ./aws/install --update

# Clean up the downloaded zip archive and extracted files
rm -rf aws awscliv2.zip

# Install Ansible configuration management and automation tool
echo "-----Installing Ansible"

sudo apt install -y ansible

# Print validation banner and verify versions of installed tools
echo
echo "-----Installed Versions-----"

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