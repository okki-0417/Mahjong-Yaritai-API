module RedisCacheable
  extend ActiveSupport::Concern

  included do
    def redis_set(key:, value:)
      $redis.set(key.to_s, value.to_s)
    end

    def redis_get(key)
      $redis.get(key.to_s)
    end
  end
end
