## 镜像导入

```shell
k3d image import bohr_chain -c bohr-chain
```

### 公共Pvc   

```shell
kubectl apply -f genesis-json-pvc.yaml -n bohr-prod &&
kubectl apply -f genesis-keys-pvc.yaml -n bohr-prod

kubectl delete pvc genesis-keys-pvc -n bohr-prod &&
kubectl delete pvc genesis-json-pvc -n bohr-prod
```

### 公共 ConfigMap

```shell
kubectl create configmap node-config --from-file=./cm/node-config.toml -n bohr-prod  && 
kubectl create configmap genesis-config --from-file=./cm/genesis.json -n bohr-prod 

kubectl delete configmap node-config -n bohr-prod  &&
kubectl delete configmap genesis-config -n bohr-prod 
```

### Validator first

```shell

kubectl apply -f chain-node-validator-first-sts.yaml -n bohr-prod &&
kubectl apply -f chain-node-validator-sts.yaml -n bohr-prod &&
kubectl apply -f chain-node-rpc-sts.yaml -n bohr-prod 

kubectl logs -f -n bohr-prod validator-first-0 -c generate-genesis
kubectl logs -f -n bohr-prod validator-first-0 -c validator-first
kubectl logs -f -n bohr-prod chain-node-validator-first-0 -c chain-node-validator-first
    kubectl logs -f -n bohr-prod chain-node-validator-0 -c chain-node-validator
kubectl logs -f -n bohr-prod chain-node-rpc-0 -c chain-node-rpc

kubectl exec -it -n bohr-prod chain-node-validator-first-0 -- /bin/bash

kubectl delete statefulset chain-node-validator-first -n bohr-prod &&
kubectl delete statefulset chain-node-validator -n bohr-prod &&
kubectl delete statefulset chain-node-rpc -n bohr-prod &&
kubectl delete statefulset chain-node-validator -n bohr-prod &&
kubectl delete pvc validator-data-validator-first-0 -n bohr-prod 
kubectl delete svc chain-node-validator-first -n bohr-prod 
```

### Validator

```shell
kubectl apply -f validator-statefulset.yaml -n bohr-prod &&
kubectl apply -f validator-service.yaml -n bohr-prod

kubectl logs -f -n bohr-prod validator-0 -c validator

kubectl exec -it -n bohr-prod chain-node-validator-0 -- /bin/bash

kubectl delete statefulset chain-node-validator -n bohr-prod &&
kubectl delete pvc validator-data-pvc-validator-0 -n bohr-prod &&
kubectl delete pvc validator-data-pvc-validator-1 -n bohr-prod

```

###### RPC

```shell
kubectl apply -f ./sts/chain-node-rpc-sts.yaml  -n bohr-prod &&
kubectl apply -f ./svc/chain-node-rpc-svc.yaml -n bohr-prod

kubectl logs -f -n bohr-prod chain-node-rpc-0 -c chain-node-rpc

kubectl delete statefulset chain-node-rpc -n bohr-prod &&
kubectl delete pvc rpc-data-rpc-node-0  -n bohr-prod &&
kubectl delete pvc rpc-data-rpc-node-1  -n bohr-prod &&
kubectl delete pvc rpc-data-rpc-node-2  -n bohr-prod 

kubectl describe pod chain-node-rpc-0 -n bohr-prod 

kubectl exec -it -n bohr-prod chain-node-rpc-0 -- /bin/bash
kubectl delete pod  rpc-node-0 -n bohr-prod
kubectl describe pod -n bohr-prod validator-0

```

### Job

```shell
kubectl apply -f genesis-job.yaml -n bohr-prod
kubectl logs -f -n bohr-prod job/generate-genesis
kubectl delete job generate-genesis -n bohr-prod 
```

### 更新镜像

```shell
kubectl set image statefulset/validator-first validator-first=630968570112.dkr.ecr.ap-northeast-1.amazonaws.com/bohr-prod/chain:test-84cd25-20251214025041 -n bohr-prod  
kubectl set image statefulset/validator validator=630968570112.dkr.ecr.ap-northeast-1.amazonaws.com/bohr-prod/chain:test-84cd25-20251214025041 -n bohr-prod
kubectl set image statefulset/rpc-node rpc-node=630968570112.dkr.ecr.ap-northeast-1.amazonaws.com/bohr-prod/chain:test-84cd25-20251214025041 -n bohr-prod  
````

### 其他

```shell
kubectl get pod -n bohr-prod
kubectl get job -n bohr-prod
kubectl get svc -n bohr-prod
kubectl get pvc -n bohr-prod
kubectl get configmap -n bohr-prod
kubectl get statefulset -n bohr-prod

0x79c9dd074687640ac1d73b759f57a1e8cad907921bf69b0fc61d5e211c8df1dd
c3351b02603ac61e4db136783ecd28b16b703c1b8b5c5fd34ddab2387535a62303718dfbe0c1a9c198074e8c07a47a63ed5a41de2031e722cd7a2b588a50c5dc

$BIN_DIR/tf --rpc http://127.0.0.1:8545 \
--prk XXX \
--to Val0x7a0475f365ebace0bac076506a05c4e7c3cf9ad5 \
--amount 21000

$BIN_DIR/tf --rpc http://127.0.0.1:8545 \
--prk XXX \
--to 0x0cb3420ba5f76d5df45f8d4e017258c025dc9d9c \
--amount 21000

curl -X POST http://127.0.0.1:8545 \
-H "Content-Type: application/json" \
-d '{
"jsonrpc": "2.0",
"method": "eth_getBalance",
"params": ["0xe760f6d73b091348e5b7bb7290cc9808b2a53287", "latest"],
"id": 1
}'
```














