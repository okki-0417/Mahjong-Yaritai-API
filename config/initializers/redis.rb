# config/initializers/redis.rb
$redis = Redis.new(url: ENV.fetch("REDIS_URL"))
