### Command line for Kubernetes Deployment

###### Deployment

```shell
#kubectl apply -f bridge-relayer-test-sts.yaml  -n bohr-prod 
kubectl apply -f bridge-api-deployment.yaml  -n bohr-prod &&
kubectl apply -f bridge-relayernode-deployment.yaml  -n bohr-prod 

kubectl logs -f -n bohr-prod bridge-relayer-0 -c bridge-relayer
kubectl logs -f bohrdex-subgraph-fhsrn -c bohrdex-subgraph

kubectl get deployment -n bohr-prod


kubectl delete deployment bridge-api -n bohr-prod &&
kubectl delete deployment bridge-relayernode -n bohr-prod

kubectl exec -it -n bohr-prod bridge-relayer-0 -- /bin/bash
kubectl delete pod  rpc-node-0 -n bohr-prod
kubectl delete deployment  bridge-relayernode -n bohr-prod
kubectl describe pod -n bohr-prod bridge-relayernode-d44577ddd-4wx8v
```

### Service

```shell
kubectl apply -f genesis-job.yaml -n bohr-prod

kubectl get svc -n bohr-prod
 
```
