require_relative "boot"

require "rails/all"
require "dotenv/load"
require "custom_logger"

Bundler.require(*Rails.groups)

module MahjongYaritaiApp
  class Application < Rails::Application
    config.active_record.query_log_tags_enabled = true
    config.active_record.query_log_tags = [
      # Rails query log tags:
      :application, :controller, :action, :job,
      # GraphQL-Ruby query log tags:
      current_graphql_operation: -> { GraphQL::Current.operation_name },
      current_graphql_field: -> { GraphQL::Current.field&.path },
      current_dataloader_source: -> { GraphQL::Current.dataloader_source_class },
    ]
    config.load_defaults 7.2
    config.time_zone = "Tokyo"

    config.i18n.default_locale = :ja

    config.middleware.insert_before Rails::Rack::Logger, Rack::ConditionalLogger do |env|
      env["PATH_INFO"] !~ %r{^/up}
    end

    MahjongYaritaiApp::Application.config.middleware.swap Rails::Rack::Logger, CustomLogger

    config.api_only = true
    config.action_dispatch.cookies_same_site_protection = :none

    config.autoload_lib(ignore: %w[assets tasks])

    Dir[Rails.root.join("app/*")].each do |path|
      config.autoload_paths << path if File.directory?(path)
    end
  end
end
