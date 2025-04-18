require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.middleware.use ActionDispatch::Cookies
  config.middleware.use ActionDispatch::Session::RedisStore

  config.session_store :redis_store,
                        servers: [
                          ENV.fetch("REDIS_URL")
                        ],
                        cluster: true,
                        expire_after: 20.years,
                        key: "_api_app_session",
                        secure: true

  config.cache_store = :redis_cache_store, {
    urls: [
      ENV.fetch("REDIS_URL")
    ]
  }

  config.hosts << "10.0.1.136:3001"
  config.hosts << "18.177.116.156"

  config.assume_ssl = true
  config.force_ssl = true
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  config.active_storage.draw_routes = false

  config.action_mailer.default_url_options = { host: ENV.fetch("HOST_NAME") }

  config.eager_load = true
  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
end
