#!/bin/bash
set -e

rm -f tmp/pids/server.pid

# production環境の場合のみ
if [ "$RAILS_ENV" = "production" ]; then
  # --------------------------------------
  # 本番環境（AWS ECS）への初回デプロイ時に利用
  # 初回デプロイ後にコメントアウトして下さい
  bundle exec rails db:create
  # --------------------------------------
  # マイグレーション処理
  bundle exec rails db:migrate

  bundle exec rails db:seed
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
