require "active_support/core_ext/integer/time"
require "custom_logger"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  config.middleware.use ActionDispatch::Cookies
  config.middleware.use ActionDispatch::Session::RedisStore

  config.active_storage.service = :local

  config.session_store :redis_store,
                        servers: [
                          ENV.fetch("REDIS_URL")
                        ],
                        key: "_mahjong_yaritai_session",
                        secure: true

  config.cache_store = :redis_cache_store, {
    urls: [
      ENV.fetch("REDIS_URL")
    ]
  }

  MahjongYaritaiApp::Application.config.middleware.swap Rails::Rack::Logger, CustomLogger

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:         "smtp.gmail.com",             # Gmail の SMTP サーバー
    port:            587,                          # STARTTLS を使うポート
    domain:          "mahjong-yaritai.com",        # 自分のドメイン名（正確に指定することが推奨）
    user_name:       ENV.fetch("MAIL_ADDRESS"),
    password:        ENV.fetch("MAIL_PASSWORD"),
    authentication:  "plain",                      # 認証方式（通常は "plain" で問題なし）
    enable_starttls: true,                         # STARTTLS を使用して暗号化
    open_timeout:    5,
    read_timeout:    5
  }
  config.action_mailer.default_url_options = { host: ENV.fetch("FRONTEND_HOST") }

  config.hosts << ENV.fetch("HOST_NAME")
  config.hosts << "10.0.1.136:3001"
  config.hosts << "18.177.116.156"

  config.assume_ssl = true
  config.force_ssl = true
  config.log_tags = [ :request_id ]
  config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.active_support.report_deprecations = false

  config.active_storage.draw_routes = false

  config.eager_load = true
  config.i18n.fallbacks = true
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]
end
