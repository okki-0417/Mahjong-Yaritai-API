require 'redis'
require 'redis-clustering'

Redis.current = Redis::Cluster.new(
  nodes: [
    ENV.fetch("REDIS_URL")
  ],
  timeout: 5.0
)
