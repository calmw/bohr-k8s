#!/usr/bin/env bash

echo "启动 explorer ..."
kubectl apply -f scan-backend-dets-pvc.yaml -n bohr-prod &&
kubectl apply -f scan-backend-logs-pvc.yaml -n bohr-prod &&
kubectl apply -f scan-backend-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-frontend-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-stats-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-visualizer-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-sig-provider-deployment.yaml -n bohr-prod &&
kubectl apply -f scan-backend-service.yaml -n bohr-prod &&
kubectl apply -f scan-frontend-service.yaml -n bohr-prod &&
kubectl apply -f scan-stats-service.yaml -n bohr-prod &&
kubectl apply -f scan-visualizer-service.yaml -n bohr-prod &&
kubectl apply -f scan-sig-provider-service.yaml -n bohr-prod &&
kubectl apply -f db-init-job.yaml -n bohr-test &&
kubectl apply -f stats-db-init-job.yaml -n bohr-test &&
kubectl apply -f scan-stats-ingress.yaml -n bohr-test &&
kubectl apply -f scan-nginx-ingress.yaml -n bohr-test &&
kubectl apply -f scan-api-ingress.yaml -n bohr-test

echo "等待 20 秒..."
sleep 20
echo "查看日志 kubectl get pod -n bohr-prod "
