# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[destroy]

  def show
    Rails.logger.info "current_user: #{current_user&.inspect}"
    Rails.logger.info "logged_in?: #{logged_in?}"
    Rails.logger.info "session: #{session.inspect}"
    Rails.logger.info "session[:user_id]: #{session[:user_id]}"
    Rails.logger.info "cookies: #{cookies.inspect}"
    Rails.logger.info "cookies.signed[:user_id]: #{cookies.signed[:user_id]}"
    Rails.logger.info "cookies.signed[:remember_token]: #{cookies.signed[:remember_token]}"

    render json: current_user,
      serializer: SessionSerializer,
      root: :session,
      status: :ok
  end

  def destroy
    logout
    head :no_content
  end
end
