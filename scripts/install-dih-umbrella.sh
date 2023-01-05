#!/bin/bash

# Deploying xap umbrella
source ../setAWSEnv.sh
helm repo add gigaspaces https://resources.gigaspaces.com/helm-charts
helm repo update
helm install xap gigaspaces/xap --version=16.2.1 --set license="Product=InsightEdge;Version=16.2;Type=ENTERPRISE;Customer=Gigaspaces_K8sAWSEnvTraining_DEV;Expiration=2025-Jan-01;Hash=PPSPYPQcOrQZvNSfORgd"

./install-k8s-dashboard.sh
./get-k8s-dashboard-token.sh
kubectl apply -f ../yaml/grafana-lb.yaml
kubectl annotate service xap-xap-manager-service Project=CSM,Owner=CSM
./get-ui-urls.sh
echo "It will take a while for the load balancer to be available ..."


# MANAGER_URL=$(kubectl get svc -A |grep xap-xap-manager-service |grep LoadBalancer |awk '{print $5}'):$( kubectl get svc -A |grep xap-xap-manager-service |grep LoadBalancer |awk '{print $6}'|cut -d':' -f1)
# echo "Waiting for GS cluster ..."
# while [ $(/usr//bin/curl -s -o /dev/null -w %{http_code} ${MANAGER_URL}) -eq 000 ] ; do
#   echo -e $(date) " Ops Manager HTTP state: " $(/usr/bin/curl -s -o /dev/null -w %{http_code} ${MANAGER_URL}) " (waiting for 200)"
#   sleep 3
# done


