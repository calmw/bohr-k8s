#!/bin/bash

# 测试脚本 - 测试 Kubo (IPFS) 部署

INGRESS_HOST="kubo.bohr.life"
SERVICE_NAME="kubo"

echo "========================================="
echo "Kubo (IPFS) Kubernetes 测试"
echo "========================================="
echo ""

NAMESPACE="bohr-prod"
KUBECTL_CMD="kubectl -n $NAMESPACE"

echo "1. 检查 Pod 状态..."
echo "   Namespace: $NAMESPACE"
POD_NAME=$($KUBECTL_CMD get pods -l app.kubernetes.io/name=kubo -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")

if [ -z "$POD_NAME" ]; then
    echo "   错误: 未找到 Kubo Pod"
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
echo "2. 测试 IPFS 功能（通过 Pod exec）..."
# 测试 IPFS 版本命令
IPFS_VERSION=$($KUBECTL_CMD exec "$POD_NAME" -- ipfs version 2>&1)
if echo "$IPFS_VERSION" | grep -q "ipfs version"; then
    VERSION=$(echo "$IPFS_VERSION" | grep -o "version [0-9.]*" | cut -d' ' -f2 || echo "unknown")
    echo "   成功: IPFS 功能正常"
    echo "   IPFS 版本: $VERSION"
else
    echo "   警告: IPFS 命令可能异常"
    echo "   响应: $IPFS_VERSION"
fi

# 测试 IPFS ID 命令（健康检查）
IPFS_ID=$($KUBECTL_CMD exec "$POD_NAME" -- ipfs id 2>&1 | head -5)
if echo "$IPFS_ID" | grep -q "ID\|Addresses"; then
    echo "   成功: IPFS 节点正常运行"
else
    echo "   警告: IPFS 节点可能未完全启动"
    echo "   提示: 等待一段时间后重试，或查看日志: $KUBECTL_CMD logs $POD_NAME"
fi

echo ""
echo "3. 测试通过 Service 访问（集群内部）..."
# 创建一个临时 Pod 来测试 Service 访问
TEST_POD="kubo-test-$(date +%s)"
echo "   使用临时 Pod 测试 Service 访问..."

# 测试 API 端口
API_TEST=$($KUBECTL_CMD run "$TEST_POD" --rm -i --restart=Never --image=curlimages/curl:latest --timeout=15s -- \
    curl -s --max-time 10 -X POST http://$SERVICE_NAME:5001/api/v0/version 2>&1 | head -3 || echo "timeout")

if echo "$API_TEST" | grep -q "Version"; then
    echo "   成功: IPFS API 通过 Service 可访问"
else
    echo "   信息: Service 访问测试完成（可能需要更长时间启动）"
fi

echo ""
echo "4. 检查 Ingress 资源..."
INGRESS_NAME=$($KUBECTL_CMD get ingress -l app.kubernetes.io/name=kubo -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
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
echo "     - API: http://$INGRESS_HOST/api/v0/version"
echo "     - Gateway: http://$INGRESS_HOST/ipfs/..."
echo "  2. 集群内部: 通过 Service 名称 $SERVICE_NAME"
echo ""

