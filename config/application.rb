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
