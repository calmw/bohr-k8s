#!/bin/bash


SERVICE_NAME="graph-node"
INGRESS_HOST="graph-node.bohr.life"

echo "========================================="
echo "Graph Node Kubernetes 测试"
echo "========================================="
echo ""

NAMESPACE="bohr-prod"
KUBECTL_CMD="kubectl -n $NAMESPACE"

echo "1. 检查 Pod 状态..."
echo "   Namespace: $NAMESPACE"
POD_NAME=$($KUBECTL_CMD get pods -l app.kubernetes.io/name=graph-node -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")

if [ -z "$POD_NAME" ]; then
    echo "   错误: 未找到 Graph Node Pod"
    exit 1
fi

POD_STATUS=$($KUBECTL_CMD get pod "$POD_NAME" -o jsonpath='{.status.phase}')
echo "   Pod: $POD_NAME"
echo "   状态: $POD_STATUS"

if [ "$POD_STATUS" != "Running" ]; then
    echo "   错误: Pod 未运行，请检查日志："
    echo "   kubectl logs $POD_NAME -n $NAMESPACE"
    exit 1
fi

echo "   成功: Pod 正在运行"

echo ""
echo "2. 检查 Ingress 资源..."
INGRESS_NAME=$($KUBECTL_CMD get ingress -l app.kubernetes.io/name=graph-node -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -z "$INGRESS_NAME" ]; then
    echo "   警告: Ingress 资源不存在，请检查部署"
    exit 1
fi

echo "   Ingress 资源存在: $INGRESS_NAME"
$KUBECTL_CMD get ingress "$INGRESS_NAME"
echo "   提示: Ingress 访问测试需要在其他机器上进行，部署机器无法直接访问"

echo ""
echo "========================================="
echo "测试完成！"
echo "========================================="
echo ""
echo "部署状态总结："
if [ -n "$POD_NAME" ]; then
    echo "  - Pod: $POD_NAME (运行中)"
    echo "  - 查看日志: kubectl logs -f $POD_NAME -n $NAMESPACE"
    echo "  - Namespace: $NAMESPACE"
fi
echo "  - Service: $SERVICE_NAME (集群内部访问)"
echo ""
echo "访问方式："
echo "  1. Ingress: http://$INGRESS_HOST (需要在其他机器上访问)"
echo "     - GraphQL API: http://$INGRESS_HOST/subgraphs/name/ctcdex/ctcdex-subgraph"
echo "     - 根路径: http://$INGRESS_HOST/"
echo "  2. 集群内部: 通过 Service 名称 $SERVICE_NAME"
echo ""
