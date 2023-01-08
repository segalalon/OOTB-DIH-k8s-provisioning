#!/bin/bash
# Configure aws and kubectl 
echo
echo "To config your kubectl to connect your cluster:"
echo " aws eks update-kubeconfig --name <clusteName>"
echo "Test it by running: kubectl get svc"
echo 
echo "Your cluster name is stored in clusterName.txt"


