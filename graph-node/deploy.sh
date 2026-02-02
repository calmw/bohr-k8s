#!/bin/bash

# 部署脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NAMESPACE="bohr-prod"
KUBECTL_CMD="kubectl -n $NAMESPACE"

echo "========================================="
echo "Graph Node Kubernetes 部署"
echo "========================================="
echo "Namespace: $NAMESPACE"
echo ""

echo "1. 部署 Deployment..."
$KUBECTL_CMD apply -f "$SCRIPT_DIR/deployment.yaml"

echo ""
echo "2. 部署 Service..."
$KUBECTL_CMD apply -f "$SCRIPT_DIR/service.yaml"

echo ""
echo "3. 部署 Ingress..."
$KUBECTL_CMD apply -f "$SCRIPT_DIR/ingress.yaml"

echo ""
echo "4. 等待 Pod 就绪..."
$KUBECTL_CMD wait --for=condition=ready pod -l app.kubernetes.io/name=graph-node --timeout=600s 2>/dev/null || {
    echo "   等待超时，检查 Pod 状态..."
    $KUBECTL_CMD get pods -l app.kubernetes.io/name=graph-node
}

echo ""
echo "5. 显示部署状态..."
echo ""
echo "Pod 状态:"
$KUBECTL_CMD get pods -l app.kubernetes.io/name=graph-node
echo ""
echo "Service 状态:"
$KUBECTL_CMD get service -l app.kubernetes.io/name=graph-node
echo ""
echo "Ingress 状态:"
$KUBECTL_CMD get ingress -l app.kubernetes.io/name=graph-node 2>/dev/null || echo "   Ingress 未找到"

echo ""
echo "========================================="
echo "部署完成！"
echo "========================================="
echo ""

