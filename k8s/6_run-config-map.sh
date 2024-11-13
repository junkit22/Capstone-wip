# Check ingress resources
echo " updated configuration by redeploying the modified manifest"
kubectl apply -f prometheus-deployment.yaml
