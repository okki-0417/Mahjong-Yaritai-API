# frozen_string_literal: true

class HealthCheckController < ApplicationController
  rescue_from(StandardError) { head :internal_server_error }

  def show
    Rails.logger.info("redis://#{ENV.fetch("REDIS_HOST")}:#{ENV.fetch("REDIS_PORT")}")
    head :ok
  end
end
