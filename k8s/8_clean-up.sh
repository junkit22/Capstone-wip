helm uninstall nginx-ingress
kubectl delete clusterrole nginx-ingress-ingress-nginx
kubectl delete clusterrole prometheus-stack-grafana-clusterrole  
helm uninstall prometheus-stack --namespace default

