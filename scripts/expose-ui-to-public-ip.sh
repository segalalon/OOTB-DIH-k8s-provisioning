kubectl patch svc xap-grafana -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc kubernetes-dashboard -n kubernetes-dashboard -p '{"spec": {"type": "LoadBalancer"}}'

