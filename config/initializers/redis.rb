require 'redis'
require 'redis-clustering'

Redis.current = Redis.new(
  cluster: [
    'redis://clustercfg.mahjong-yaritai.fggao1.apne1.cache.amazonaws.com:6379'
  ],
  timeout: 5.0
)
