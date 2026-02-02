#!/bin/bash
set -e

PGHOST="bohr-prod-pg.cluster-cbagk0a62xfv.ap-northeast-1.rds.amazonaws.com"
PGPORT="5432"
PGUSER="postgres"
DB_NAME="stats"

echo "⚠️ 即将【删除并重建】数据库: $DB_NAME"
read -p "确认操作？(yes/no): " confirm

if [ "$confirm" != "yes" ]; then
  echo "已取消"
  exit 0
fi

psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d postgres <<EOF
-- 1. 断开所有连接
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = '${DB_NAME}'
  AND pid <> pg_backend_pid();

-- 2. 删除数据库
DROP DATABASE IF EXISTS ${DB_NAME};

-- 3. 重新创建数据库
CREATE DATABASE ${DB_NAME};
EOF

echo "✅ 数据库 ${DB_NAME} 已删除并重新创建（已清空）"
