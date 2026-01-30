#!/bin/bash

# 清理脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NAMESPACE="bohr-test"
KUBECTL_CMD="kubectl -n $NAMESPACE"

echo "========================================="
echo "Graph Node Kubernetes 清理"
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
echo "========================================="
echo "清理完成！"
echo "========================================="
echo ""
