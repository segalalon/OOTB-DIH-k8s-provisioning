kubectl -n kubernetes-dashboard create token admin-user > k8s-dashboard-token.txt
echo >> k8s-dashboard-token.txt
echo
echo k8s token:
echo ----------
cat k8s-dashboard-token.txt
echo

