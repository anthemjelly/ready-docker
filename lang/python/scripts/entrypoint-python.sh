#!/bin/sh

echo "Entrypoint：激活 Python 虛擬環境 ($VIRTUAL_ENV)"
. "$VIRTUAL_ENV/bin/activate"

# PostgreSQL/Redis加等待邏輯
# while ! curl -s db:5432; do sleep 1; done

echo "Entrypoint：執行命令：$*"
exec "$@"