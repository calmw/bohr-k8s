## 镜像导入

```shell
k3d image import bohr_chain -c bohr-chain
```

## 创建集群

```shell
k3d cluster create blockscout-cluster
```

## 命名空间

```shell
kubectl create ns bohr-test
kubectl config set-context --current --namespace=bohr-test
```

### Pvc

```shell
kubectl apply -f scan-backend-dets-pvc.yaml -n bohr-test &&
kubectl apply -f scan-backend-logs-pvc.yaml -n bohr-test 

kubectl delete pvc scan-backend-dets-pvc -n bohr-test &&
kubectl delete pvc scan-backend-logs-pvc -n bohr-test 

```

### Deployment

```shell
kubectl apply -f scan-backend-deployment.yaml -n bohr-test &&
kubectl apply -f scan-frontend-deployment.yaml -n bohr-test &&
kubectl apply -f scan-stats-deployment.yaml -n bohr-test &&
kubectl apply -f scan-visualizer-deployment.yaml -n bohr-test &&
kubectl apply -f scan-sig-provider-deployment.yaml -n bohr-test

kubectl logs -f -n bohr-test scan-backend-66748955bb-xqnbj -c scan-backend

kubectl exec -it -n bohr-test scan-backend -- /bin/bash
kubectl describe pod -n bohr-test scan-backend-587769b845-krf7r
  
kubectl delete deployment scan-backend -n bohr-test  &&
kubectl delete deployment scan-frontend -n bohr-test  &&
kubectl delete deployment scan-sig-provider -n bohr-test  &&
kubectl delete deployment scan-stats -n bohr-test  &&
kubectl delete deployment scan-visualizer -n bohr-test  
```

#### Service

```shell
kubectl apply -f scan-backend-service.yaml -n bohr-test &&
kubectl apply -f scan-frontend-service.yaml -n bohr-test &&
kubectl apply -f scan-stats-service.yaml -n bohr-test &&
kubectl apply -f scan-visualizer-service.yaml -n bohr-test &&
kubectl apply -f scan-sig-provider-service.yaml -n bohr-test

kubectl delete service scan-backend -n bohr-test &&
kubectl delete service scan-frontend -n bohr-test &&
kubectl delete service scan-stats -n bohr-test &&
kubectl delete service scan-visualizer -n bohr-test &&
kubectl delete service scan-sig-provider -n bohr-test
```

#### Secret

```shell
kubectl apply -f stats-env.yaml -n bohr-test

kubectl get secret stats-env -n bohr-test

kubectl delete secret stats-env -n bohr-test
```

#### Job

```shell
kubectl apply -f db-init-job.yaml -n bohr-test &&
kubectl apply -f stats-db-init-job.yaml -n bohr-test 

kubectl describe pod -n bohr-test stats-db-init-55bw6
kubectl logs -f -n bohr-test stats-db-init-55bw6

kubectl delete job db-init -n bohr-test &&
kubectl delete job stats-db-init -n bohr-test 

```
#### Ingress

```shell
kubectl apply -f scan-stats-ingress.yaml -n bohr-test &&
kubectl apply -f scan-nginx-ingress.yaml -n bohr-test &&
kubectl apply -f scan-api-ingress.yaml -n bohr-test

kubectl get ingress -n bohr-test

kubectl delete ingress scan-ingress -n bohr-test  &&
kubectl delete ingress scan-stats -n bohr-test &&
kubectl delete ingress scan-api -n bohr-test 

```

#### DB

```shell
psql -h bohr-test-instance-1.cbagk0a62xfv.ap-northeast-1.rds.amazonaws.com -p 5432 -U postgres

\ scan;
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;




```