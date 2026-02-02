#!/usr/bin/env bash

kubectl delete deployment scan-backend -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete deployment scan-stats -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete deployment scan-frontend -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete pvc scan-backend-dets-pvc -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete pvc scan-backend-logs-pvc -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl apply -f scan-backend-dets-pvc.yaml -n bohr-prod &&
kubectl apply -f scan-backend-logs-pvc.yaml -n bohr-prod
