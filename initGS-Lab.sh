#!/bin/bash
# Get lab name from user
# read -p 'Please enter your name: ' replaceName
# mkdir -p tmp

# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
# sudo yum install -y yum-utils unzip wget git terraform
# # wget terraform code from s3

# # Install kubectl
# cd tmp
# curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# cd ..

# # Install helm
# cd tmp
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
# chmod 700 get_helm.sh
# ./get_helm.sh
# cd ..

# # Install awscli
# cd tmp
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip -o awscliv2.zip
# sudo ./aws/install --update
# cd ..

# Provision EKS cluster using terraform
clear
# Set AWS CSM-LAB credentials
echo "Testing AWS credentials ..."
source ./setAWSEnv.sh
awscreds=$(aws sts get-caller-identity)
if [[ `echo "${awscreds}" |grep Arn |wc -l` = 0 ]];then
    echo "Please edit the setAWSEnv.sh file and run again."
    exit
fi 
echo ${awscreds} |json_reformat
echo
read -r -p "Continue with the above AWS crdentailes? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        
        ;;
    *)
        echo "Aborted."
        exit
        ;;
esac

read -p 'Please enter a project name (i.e: GMTS380-James): ' replaceName
mkdir -p tmp
cp terraform/primary_site/project_configuration.tmp terraform/primary_site/project_configuration.tf

# Update the project name for this deployment
sed -i "s/replaceName/$replaceName/g" terraform/primary_site/project_configuration.tf
sed -i "s/replaceOwner/$replaceName/g" terraform/primary_site/project_configuration.tf
cd terraform
terraform init
tf_ready=$(terraform plan -out create.out |grep "run the following command to apply" |wc -l)
if [[ ${tf_ready} = 0 ]];then
    echo "Terraform preparation has been failed, please check the errors."
    exit
fi
terraform apply "create.out"

#Configure aws 
clustername=`aws eks list-clusters |grep ${replaceName} |xargs`
aws eks update-kubeconfig --name ${clustername}
kubectl get svc




