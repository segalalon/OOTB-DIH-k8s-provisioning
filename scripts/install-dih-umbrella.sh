#kubectl apply -f ../yaml/grafana-lb.yaml
helm install xap gigaspaces/xap --version=16.2.1 --set license="Product=InsightEdge;Version=16.2;Type=ENTERPRISE;Customer=Gigaspaces_K8sAWSEnvTraining_DEV;Expiration=2025-Jan-01;Hash=PPSPYPQcOrQZvNSfORgd"
kubectl patch svc xap-grafana -p '{"spec": {"type": "LoadBalancer"}}'
./install-k8s-dashboard.sh
./get-k8s-dashboard-token.sh
./get-ui-urls.sh
kubectl get svc,pods