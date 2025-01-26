require 'redis'
require 'redis-clustering'

$redis = Redis::Cluster.new(
  nodes: [
    ENV.fetch("REDIS_URL")
  ],
  timeout: 5.0
)
