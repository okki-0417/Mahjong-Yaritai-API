Sidekiq.configure_server do |config|
  config.redis = {
    host: ENV.fetch("REDIS_HOST", "localhost"),
    port: ENV.fetch("REDIS_PORT", 6379).to_i,
    db: 1,
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    host: ENV.fetch("REDIS_HOST", "localhost"),
    port: ENV.fetch("REDIS_PORT", 6379).to_i,
    db: 1,
  }
end
