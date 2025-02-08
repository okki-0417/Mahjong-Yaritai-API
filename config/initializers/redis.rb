require 'redis-rails'
require 'redis-clustering' if Rails.env.production?

if Rails.env.production?
  $redis = Redis::Cluster.new(
    nodes: [
      ENV.fetch("REDIS_URL")
    ],
    timeout: 5.0
  )
else
  $redis = Redis.new(url: ENV.fetch("REDIS_URL"))
end
