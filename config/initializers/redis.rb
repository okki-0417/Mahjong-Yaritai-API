require 'redis'
require 'redis-clustering'

Redis.current = Redis.new(
  cluster: [
    ENV.fetch("REDIS_URL")
  ],
  timeout: 5.0
)
