#!/bin/bash
# Configure aws and kubectl 
source ../setAWSEnv.sh
aws eks update-kubeconfig --name `cat ../clusterName.txt`
echo
echo "To config your kubectl to connect your cluster please run:"
echo " aws eks update-kubeconfig --name `cat ../clusterName.txt`"
echo
echo "Test it by running: kubectl get svc"
echo 
echo "Your cluster name is stored in clusterName.txt"
