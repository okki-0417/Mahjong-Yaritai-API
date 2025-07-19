# frozen_string_literal: true

module Authenticatable
  include ActionController::Cookies

  def login(user)
    reset_session

    session[:user_id] = user.id
  end

  def remember(user)
    user.remember

    cookies.permanent.signed[:user_id] = {
      domain: ENV.fetch("ETLD_HOST"),
      value: user.id,
      same_site: :lax,
      secure: Rails.env.production?,
      httponly: true,
    }

    cookies.permanent.signed[:remember_token] = {
      domain: ENV.fetch("ETLD_HOST"),
      value: user.remember_token,
      same_site: :lax,
      secure: Rails.env.production?,
      httponly: true,
    }
  end

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

  def logout
    forget current_user
    reset_session
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logged_in?
    current_user.present?
  end
end
