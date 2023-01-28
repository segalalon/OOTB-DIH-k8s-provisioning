#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH

# Deploying xap umbrella
source ../setAWSEnv.sh
helm repo add gigaspaces https://resources.gigaspaces.com/helm-charts
helm repo update
helm install xap gigaspaces/xap --version=16.2.1 -f ../yaml/gigaspaces.yaml

./install-k8s-dashboard.sh
./get-k8s-dashboard-token.sh
kubectl apply -f ../yaml/grafana-lb.yaml
#kubectl apply -f ../yaml/managers-lb.yaml

# Annotate Load Balancers
cluster_name=$(cat ../clusterName.txt)
ops_manager_annotate="kubectl patch svc xap-xap-manager-service -p '{\"metadata\":{\"annotations\":{\"service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags\":\"Owner=$cluster_name, Project=$cluster_name, Name=$cluster_name-opsManager-LB\"}}}'"
eval  $ops_manager_annotate

k8s_dashboard_annotate="kubectl patch svc k8s-dashboard-lb -n kubernetes-dashboard -p '{\"metadata\":{\"annotations\":{\"service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags\":\"Owner=$cluster_name, Project=$cluster_name, Name=$cluster_name-k8s-dashboard-LB\"}}}'"
eval  $k8s_dashboard_annotate

grafana_lb_annotate="kubectl patch svc grafana-lb -p '{\"metadata\":{\"annotations\":{\"service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags\":\"Owner=$cluster_name, Project=$cluster_name, Name=$cluster_name-grafana-LB\"}}}'"
eval  $grafana_lb_annotate


./get-ui-urls.sh
echo "It will take a while for the load balancer to be available ..."
