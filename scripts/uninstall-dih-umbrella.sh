#!/bin/bash
# Delete load balancer services
#kubectl delete -f ../yaml/manager-lb.yaml
echo "Deleting LB service ..."
kubectl delete -f ../yaml/k8s-dashboard-lb.yaml
kubectl delete -f ../yaml/grafana-lb.yaml

# Delete xap umbrella
echo "Deleting DIH umbrella ..."
helm uninstall xap

# Delete k8s-dashboard
echo "Deleting k8s-dashboard"
kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml






