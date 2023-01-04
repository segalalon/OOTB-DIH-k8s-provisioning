echo k8s-dashboard: https://$(kubectl get svc -A |grep k8s-dashboard |grep LoadBalancer |awk '{print $5}'):$( kubectl get svc -A |grep k8s-dashboard |grep LoadBalancer |awk '{print $6}'|cut -d':' -f1)
echo grafana: http://$(kubectl get svc -A |grep grafana |grep LoadBalancer |awk '{print $5}'):$( kubectl get svc -A |grep grafana |grep LoadBalancer |awk '{print $6}'|cut -d':' -f1)
echo