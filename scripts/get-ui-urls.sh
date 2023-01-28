echo k8s-dashboard: https://$(kubectl get svc -A |grep kubernetes-dashboard |grep LoadBalancer |awk '{print $5}'):$( kubectl get svc -A |grep kubernetes-dashboard |grep LoadBalancer |awk '{print $6}'|cut -d':' -f1)
echo grafana: http://$(kubectl get svc -A |grep grafana-lb |grep LoadBalancer |awk '{print $5}'):$( kubectl get svc -A |grep grafana-lb |grep LoadBalancer |awk '{print $6}'|cut -d':' -f1)
echo ops-ui: http://$(kubectl get svc -A |grep xap-xap-manager-service |grep LoadBalancer |awk '{print $5}'):8090
echo
