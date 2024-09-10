#!/bin/bash

# Update package lists
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg software-properties-common unzip

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl kubectl.sha256
kubectl_version=$(kubectl version --client --short)
echo "kubectl installed: $kubectl_version"

# Install eksctl
echo "Installing eksctl..."
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | sudo tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl_version=$(eksctl version)
echo "eksctl installed: $eksctl_version"

# Install AWS CLI version 2
echo "Installing AWS CLI version 2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws_version=$(aws --version)
echo "AWS CLI installed: $aws_version"
rm -rf awscliv2.zip aws

# Install Helm
echo "Installing Helm..."
curl -fsSL https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://baltocdn.com/helm/stable/debian/ all main"
sudo apt-get update
sudo apt-get install -y helm
helm_version=$(helm version --short)
echo "Helm installed: $helm_version"

# Install Terraform
echo "Installing Terraform..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install -y terraform
terraform_version=$(terraform -v)
echo "Terraform installed: $terraform_version"

echo "All installations completed successfully."
