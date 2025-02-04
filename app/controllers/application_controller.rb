class ApplicationController < ActionController::API
  include SessionHelper
  include RedisCacheable

  include Rails.application.routes.url_helpers
  include ActionController::RequestForgeryProtection
end
