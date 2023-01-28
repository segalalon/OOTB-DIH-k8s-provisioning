#!/bin/bash
SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd $SCRIPTPATH

# Deploying xap umbrella
source ../setAWSEnv.sh
helm repo add gigaspaces https://resources.gigaspaces.com/helm-charts
helm repo update
helm install xap gigaspaces/xap --version=16.2.1 --set license="Product=InsightEdge;Version=16.2;Type=ENTERPRISE;Customer=Gigaspaces_K8sAWSEnvTraining_DEV;Expiration=2025-Jan-01;Hash=PPSPYPQcOrQZvNSfORgd"

./install-k8s-dashboard.sh
./get-k8s-dashboard-token.sh
kubectl apply -f ../yaml/grafana-lb.yaml
#kubectl apply -f ../yaml/managers-lb.yaml

# Annotate ops-manager LoadBalancer
cluster_name=$(cat ../clusterName.txt)
ops_manager_annotate="kubectl patch svc xap-xap-manager-service -p '{\"metadata\":{\"annotations\":{\"service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags\":\"Owner=$cluster_name, Project=$cluster_name, Name=$cluster_name-opsManager-LB\"}}}'"
eval  $ops_manager_annotate

./get-ui-urls.sh
echo "It will take a while for the load balancer to be available ..."
