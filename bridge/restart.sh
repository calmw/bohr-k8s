#!/usr/bin/env bash

kubectl delete deployment bridge-api -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl apply -f bridge-api-deployment.yaml  -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl apply -f bridge-api-service.yaml  -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl apply -f bridge-api-ingress.yaml  -n bohr-prod

echo "进入破洞启动"
echo "kubectl exec -it -n bohr-prod bridge-api -- /bin/bash"