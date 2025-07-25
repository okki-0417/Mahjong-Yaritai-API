require_relative "boot"

require "rails/all"
require "dotenv/load"

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

    config.api_only = true
    config.action_dispatch.cookies_same_site_protection = :none

    # ActiveJob configuration
    config.active_job.queue_adapter = :sidekiq

    config.autoload_lib(ignore: %w[assets tasks])

    Dir[Rails.root.join("app/*")].each do |path|
      config.eager_load_paths << path if File.directory?(path)
    end
    config.eager_load_paths << Rails.root.join("lib")
  end
end
