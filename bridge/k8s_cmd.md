### Command line for Kubernetes Deployment

###### Deployment

```shell
#kubectl apply -f bridge-relayer-test-sts.yaml  -n bohr-test 
kubectl apply -f bridge-api-deployment.yaml  -n bohr-test &&
kubectl apply -f bridge-relayernode-deployment.yaml  -n bohr-test 

kubectl logs -f -n bohr-test bridge-relayer-0 -c bridge-relayer
kubectl logs -f bohrdex-subgraph-fhsrn -c bohrdex-subgraph

kubectl get deployment -n bohr-test


kubectl delete deployment bridge-api -n bohr-test &&
kubectl delete deployment bridge-relayernode -n bohr-test

kubectl exec -it -n bohr-test bridge-relayer-0 -- /bin/bash
kubectl delete pod  rpc-node-0 -n bohr-test
kubectl delete deployment  bridge-relayernode -n bohr-test
kubectl describe pod -n bohr-test bridge-relayernode-d44577ddd-4wx8v
```

### Service

```shell
kubectl apply -f genesis-job.yaml -n bohr-test

kubectl get svc -n bohr-test
 
```
