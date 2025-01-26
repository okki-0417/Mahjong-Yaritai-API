require_relative "boot"

require "rails/all"
require 'dotenv/load'

Bundler.require(*Rails.groups)

module DefaultApp
  class Application < Rails::Application
    config.load_defaults 7.2

    config.i18n.default_locale = :ja

    config.api_only = true
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore
    config.action_dispatch.cookies_same_site_protection = :none

    config.autoload_lib(ignore: %w[assets tasks])

    config.hosts << "mahjong-yaritai.com"
  end
end
