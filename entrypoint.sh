#!/bin/bash
set -e

rm -f tmp/pids/server.pid

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:migrate

  mkdir -p log
  touch log/production.log
  chmod 664 log/production.log
fi

exec "$@"
