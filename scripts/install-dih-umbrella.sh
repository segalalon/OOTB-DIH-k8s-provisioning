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
kubectl apply -f ../yaml/managers-lb.yaml
kubectl annotate service xap-xap-manager-service Project=CSM,Owner=CSM
./get-ui-urls.sh
echo "It will take a while for the load balancer to be available ..."
