#!/bin/sh
# 這個腳本的作用：告訴 Docker 容器是否「健康」

# 檢查是否有自定義健康檢查腳本
if [ -x "/app/healthcheck" ]; then
    exec /app/healthcheck
else
    echo "通用健康檢查：預設成功"
    exit 0
fi