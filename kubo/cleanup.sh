#!/bin/bash

# 清理脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NAMESPACE="bohr-test"
KUBECTL_CMD="kubectl -n $NAMESPACE"
KUBECTL_NS_ARG="-n $NAMESPACE"

echo "========================================="
echo "Kubo (IPFS) Kubernetes 清理"
echo "========================================="
echo "Namespace: $NAMESPACE"
echo ""

echo "1. 删除 Deployment..."
$KUBECTL_CMD delete -f "$SCRIPT_DIR/deployment.yaml" 2>/dev/null || echo "   Deployment 不存在或已删除"

echo ""
echo "2. 删除 Service..."
$KUBECTL_CMD delete -f "$SCRIPT_DIR/service.yaml" 2>/dev/null || echo "   Service 不存在或已删除"

echo ""
echo "3. 删除 Ingress..."
$KUBECTL_CMD delete -f "$SCRIPT_DIR/ingress.yaml" 2>/dev/null || echo "   Ingress 不存在或已删除"


echo ""
echo "4. 删除 PersistentVolumeClaim..."
$KUBECTL_CMD delete -f "$SCRIPT_DIR/persistentvolumeclaim.yaml" 2>/dev/null || echo "   PersistentVolumeClaim 不存在或已删除"

echo ""
echo "5. 删除 PersistentVolume..."
# PersistentVolume 是集群级别资源，不使用 namespace
kubectl delete -f "$SCRIPT_DIR/persistentvolume.yaml" 2>/dev/null || echo "   PersistentVolume 不存在或已删除"

echo "========================================="
echo "清理完成！"
echo "========================================="
echo ""




