# Graph Node Kubernetes 部署

使用原生 Kubernetes YAML 文件在 Kubernetes 上部署 Graph Node。



### 端口说明

- **8000**: HTTP (GraphQL API)
- **8001**: WebSocket
- **8020**: Index Node
- **8030**: Metrics
- **8040**: Admin

## 部署步骤

### 1. 配置 Ingress

如果需要本地访问，确保 `/etc/hosts` 中包含以下条目：

```
127.0.0.1 graph-node.bohr.life
```


### 2. 部署应用

```bash
# 使用部署脚本
./deploy.sh

# 或手动部署
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
kubectl apply -f ingress.yaml
```


### 3. 测试部署

```bash
./test.sh
```

测试脚本会检查：
- Pod 状态
- Ingress 访问
- GraphQL API 响应

## 访问地址

部署成功后，可以通过以下地址访问：

- **GraphQL API**: http://graph-node.bohr.life/subgraphs/name/ctcdex/ctcdex-subgraph
- **根路径**: http://graph-node.bohr.life/

## 管理命令

### 查看 Pod 状态

```bash
kubectl get pods -l app.kubernetes.io/name=graph-node
```

### 查看日志

```bash
kubectl logs -f <pod-name>
```

### 查看 Service

```bash
kubectl get service -l app.kubernetes.io/name=graph-node
```

### 查看 Ingress

```bash
kubectl get ingress graph-node
```

### 更新配置

修改 `deployment.yaml` 文件后，重新应用：

```bash
kubectl apply -f deployment.yaml
```

### 卸载部署

```bash
# 使用清理脚本
./cleanup.sh

# 或手动删除
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f ingress.yaml
```
