# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ErrorJsonRenderable

  include Rails.application.routes.url_helpers
  include ActionController::RequestForgeryProtection

  def current_user
    if user_id = session[:user_id]
      @current_user ||= User.find_by(id: user_id)
    elsif user_id = cookies.signed[:user_id]
      return unless remember_token = cookies.signed[:remember_token]

      user = User.find_by(id: user_id)
      return unless user&.authenticated?(remember_token)

      login user
      @current_user = user
    else
      nil
    end
  end

  def reject_logged_in_user
    render json: error_json([ "Already Logged In" ]), status: :forbidden if logged_in?
  end

  def restrict_to_logged_in_user
    render json: { errors: [ message: "Please Login" ] }, status: :unauthorized unless logged_in?
  end
end
