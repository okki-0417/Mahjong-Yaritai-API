require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.debug_exception_response_format = :default
  config.eager_load = false
  config.consider_all_requests_local = true

  config.cache_store = :redis_cache_store, {
    url: ENV.fetch("REDIS_URL")
  }

  config.log_level = :debug
  config.log_tags = [:request_id]

  config.logger = ActiveSupport::Logger.new("log/development.log")

  config.active_job.queue_adapter = :sidekiq

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: ENV.fetch("HOST_NAME"), port: 3000 }

  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true
  config.active_record.query_log_tags_enabled = true

  config.action_controller.raise_on_missing_callback_actions = true
end
