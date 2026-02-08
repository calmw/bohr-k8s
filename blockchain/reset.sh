#!/usr/bin/env bash

kubectl delete statefulset chain-node-rpc -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete pvc rpc-data-chain-node-rpc-0 -n bohr-prod &&
kubectl delete pvc rpc-data-chain-node-rpc-1 -n bohr-prod &&
kubectl delete pvc rpc-data-chain-node-rpc-2 -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl delete configmap genesis-config -n bohr-prod &&
kubectl delete configmap node-config -n bohr-prod
echo "等待 10 秒..."
sleep 10
kubectl create configmap genesis-config --from-file=genesis.json -n bohr-prod&&
kubectl create configmap node-config --from-file=config.toml -n bohr-prod
echo "启动 chain-node-rpc ..."
kubectl apply -f chain-node-rpc-sts.yaml -n bohr-prod
echo "启动 chain-node-rpc service ..."
kubectl apply -f chain-node-rpc-svc.yaml -n bohr-prod
echo "启动 chain-node-rpc ingress ..."
kubectl apply -f rpc-ingress-http.yaml -n bohr-prod &&
kubectl apply -f rpc-ingress-ws.yaml -n bohr-prod

echo "等待 20 秒..."
sleep 20
echo "查看日志 kubectl logs -f --tail=30 -n bohr-prod chain-node-rpc-0 -c chain-node-rpc "
echo "查看日志 kubectl exec -it -n bohr-prod chain-node-rpc-0 -- /bin/bash "


# kubectl rollout restart statefulset chain-node-rpc -n bohr-prod
# kubectl create configmap genesis-config --from-file=genesis.json -n bohr-prod
# kubectl create configmap node-config --from-file=node-config.toml -n bohr-prod

