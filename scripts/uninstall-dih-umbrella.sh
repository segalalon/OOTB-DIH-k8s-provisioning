#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH
# Delete load balancer services

echo "Deleting LB service ..."
kubectl delete -f ../yaml/k8s-dashboard-lb.yaml
kubectl delete -f ../yaml/grafana-lb.yaml
kubectl delete -f ../yaml/managers-lb.yaml

# Delete xap umbrella
echo "Deleting DIH umbrella ..."
helm uninstall xap

# Delete k8s-dashboard
echo "Deleting k8s-dashboard"
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml






