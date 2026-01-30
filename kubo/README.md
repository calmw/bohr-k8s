# Kubernetes Kubo (IPFS) 部署

在 Kubernetes 上部署 IPFS Kubo 的配置，使用原生 Kubernetes YAML 文件。

## 应用架构

- **Deployment**: 运行 1 个 IPFS Kubo 容器
  - 健康检查：liveness 和 readiness probes
  - 资源限制：CPU 和内存限制
- **Service**: ClusterIP 类型，暴露以下端口：
  - 4001 (TCP/UDP): Swarm 端口
  - 8080: Gateway 端口
  - 8081: Gateway 备用端口
  - 5001: API 端口
- **PersistentVolume/PersistentVolumeClaim**: 持久化存储 IPFS 数据

## 标准部署方式

### 基本部署

```bash
# 使用部署脚本
./deploy.sh

# 查看部署状态
kubectl get pods -l app.kubernetes.io/name=kubo
kubectl get service -l app.kubernetes.io/name=kubo
```


## 访问应用

### 使用 Ingress

```bash
# 1. 配置本地 hosts（如果需要本地访问）
echo "127.0.0.1 kubo.bohr.life" | sudo tee -a /etc/hosts

# 2. 访问 Gateway
curl http://kubo.bohr.life

# 3. 访问 API（需要通过 /api 路径）
curl -X POST http://kubo.bohr.life/api/v0/version
```

## 部署管理

### 基本操作

```bash
# 部署所有资源
./deploy.sh

# 或手动部署
kubectl apply -f persistentvolume.yaml
kubectl apply -f ipfs-data-pvc.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 查看所有资源
kubectl get all -l app.kubernetes.io/name=kubo

# 更新配置（修改 YAML 文件后）
kubectl apply -f <resource>.yaml

# 删除资源
./cleanup.sh
```

### 配置修改

如需修改配置，直接编辑对应的 YAML 文件：

- `deployment.yaml`: 修改副本数、镜像、资源限制、启动脚本等
- `service.yaml`: 修改服务类型、端口等
- `persistentvolumeclaim.yaml`: 修改存储大小

修改后重新应用：

```bash
kubectl apply -f <resource>.yaml
```

## 使用指南

### 查看部署状态

```bash
# 查看所有资源
kubectl get all -l app.kubernetes.io/name=kubo

# 查看 Pod 状态
kubectl get pods -l app.kubernetes.io/name=kubo

# 查看 Service
kubectl get service -l app.kubernetes.io/name=kubo

# 查看详细信息
kubectl describe pod -l app.kubernetes.io/name=kubo
kubectl describe service kubo
```

### 查看日志

```bash
# 查看 Pod 日志
kubectl logs -l app.kubernetes.io/name=kubo

# 实时跟踪日志
kubectl logs -f -l app.kubernetes.io/name=kubo

# 查看特定 Pod 的日志
kubectl logs <pod-name>
```

### 测试 IPFS 功能

#### 使用测试脚本

```bash
./test.sh
```

测试脚本会检查：
- Pod 状态（必须为 Running）
- IPFS 功能（通过 Pod exec 测试）
- Service 访问（集群内部）
- Ingress 访问（如果已启用）

**判断部署成功的标准：**
- Pod 状态为 `Running`
- IPFS 版本命令正常
- IPFS ID 命令正常（节点正常运行）



### 清理资源

```bash
# 使用清理脚本
./cleanup.sh

# 或手动删除
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f ipfs-data-pvc.yaml
kubectl delete -f persistentvolume.yaml

# 注意：PersistentVolume 需要手动删除（如果使用 hostPath）
kubectl delete pv kubo-pv
sudo rm -rf /tmp/kubo-data
```
