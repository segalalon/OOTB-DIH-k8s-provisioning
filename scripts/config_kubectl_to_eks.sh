#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH
# Configure aws and kubectl
source ../setAWSEnv.sh
aws eks update-kubeconfig --name `cat ../clusterName.txt`
kubectl get svc
echo
echo
echo "If you need to reconfig your kubectl to connect your cluster, please run:"
echo "source setAWSEnv.sh"
echo "aws eks update-kubeconfig --name `cat ../clusterName.txt`"
echo
echo "Test it by running: kubectl get svc"
echo ">> Your cluster name is stored in clusterName.txt"
