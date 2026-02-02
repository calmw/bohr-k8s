#!/usr/bin/env bash

echo "启动 explorer ..."
kubectl apply -f scan-backend-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-stats-deployment.yaml -n bohr-prod

echo "等待 20 秒..."
sleep 20
echo "查看日志 kubectl get pod -n bohr-prod "
