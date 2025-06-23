# frozen_string_literal: true

class HealthCheckController < ApplicationController
  rescue_from(StandardError) { head :internal_server_error }

  def show
    Rails.logger.info("********************* ENV FRONTEND_ORIGIN: #{ENV.fetch("FRONTEND_ORIGIN")}*******************")
    head :ok
  end
end
