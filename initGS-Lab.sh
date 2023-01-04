#!/bin/bash
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
read -r -p "Continue with the above AWS crdentailes? [y/n] " response
case "$response" in
    [yY][eE][sS]|[yY]) 
        
        ;;
    *)
        echo "Aborted."
        exit
        ;;
esac

read -p 'Please enter a project name (i.e: GSTM-375-James): ' replaceName
if [[ -z "${replaceName}" ]];then
    echo "Project name cannot be empty, aborted."
    exit
fi
echo Starting provision EKS eluster
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
cd ..

# Configure aws 
clustername=`aws eks list-clusters |grep ${replaceName} |xargs`
aws eks update-kubeconfig --name ${clustername}
kubectl get svc

# Deploy k8s dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl apply -f yaml/dashboard-adminuser.yaml
kubectl apply -f yaml/clusterRoleBinding.yaml

# Deploy LB for k8s dashboard
kubectl apply -f yaml/k8s-dashboard-lb.yaml

# Deploy LB for grafana
kubectl apply -f yaml/grafana-lb.yaml

# Export token for k8s dashboard
kubectl -n kubernetes-dashboard create token admin-user > k8s-dashboard-token.txt
echo >> k8s-dashboard-token.txt





