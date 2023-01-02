#!/bin/bash

# Set AWS CSM-LAB credentials
#export AWS_ACCESS_KEY_ID="AKIATCDDMI7JKPDHHQAD"
#export AWS_SECRET_ACCESS_KEY="JmPHtFJpPZGmqE/SjUP4miDXutTArhhuhLV5iWFn"
#export AWS_DEFAULT_REGION="eu-west-1"

# Get name from user
read -p 'Please enter your name: ' replaceName
mkdir -p tmp
# Install terraform
sudo yum install -y yum-utils unzip wget
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
# wget terraform code from s3

# Install kubectl
cd tmp
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
cd ..

# Install helm
cd tmp
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
cd ..

# Install awscli
cd tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install --update
cd ..

# Provision EKS cluster using terraform
cp terraform/primary_site/project_configuration.tmp terraform/primary_site/project_configuration.tf
sed -i "s/replaceName/$replaceName/g" terraform/primary_site/project_configuration.tf
sed -i "s/replaceOwner/$replaceName/g" terraform/primary_site/project_configuration.tf
cd terraform
terraform init
terraform apply -auto-approve
cd ..

# Configure aws 
clustername=`aws eks list-clusters |grep ${replaceName} |xargs`
aws eks update-kubeconfig --name ${clustername}
kubectl get svc




