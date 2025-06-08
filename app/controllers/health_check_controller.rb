# frozen_string_literal: true

class HealthCheckController < ApplicationController
  rescue_from(Exception) { render head: 503 }

  def show
    render json: {}, status: :ok
  end
end
