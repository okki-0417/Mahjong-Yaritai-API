# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Authenticatable
  include ErrorJsonRenderable
  include Paginationable

  include Rails.application.routes.url_helpers
  include ActionController::RequestForgeryProtection

  before_action :force_logout_once

  def reject_logged_in_user
    render json: error_json([ "Already Logged In" ]), status: :forbidden if logged_in?
  end

  def restrict_to_logged_in_user
    render json: { errors: [ message: "Please Login" ] }, status: :unauthorized unless logged_in?
  end

  def force_logout_once
    return unless session[:force_logged_out].blank?

    reset_session
    session[:force_logged_out] = true
  end
end
