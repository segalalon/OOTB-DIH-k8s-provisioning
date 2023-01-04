#!/bin/bash
helm uninstall xap
kubectl delete svc dashboard-metrics-scraper kubernetes-dashboard -n kubernetes-dashboard



