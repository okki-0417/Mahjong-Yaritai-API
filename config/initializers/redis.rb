$redis = Redis.new(
  url: ENV.fetch("REDIS_URL"),
  driver: :ruby,
  cluster: %i[moved]
)
