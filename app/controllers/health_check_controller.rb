# frozen_string_literal: true

class HealthCheckController < ApplicationController
  rescue_from(StandardError) { head :internal_server_error }

  def show
    head :ok
  end
end
