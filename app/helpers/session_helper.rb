# frozen_string_literal: true

module SessionHelper
  include ActionController::Cookies

  def login(user)
    reset_session

    $redis.set(:hello_session, { user_id: user.id }.to_json)

    session[:session_key] = :hello_session
  end

  def remember(user)
    user.remember

    $redis.set(:hello_cookies, {
      user_id: user.id,
      remember_token: user.remember_token
    }.to_json)

    cookies.permanent.signed[:cookies_key] = {
      value: :hello_cookies,
      secure: true,
      httponly: true,
    }
  end

  def current_user
    if session_key = session[:session_key]
      session_value = $redis.get(session_key)

      return reset_session unless session_value

      parsed_session_value = JSON.parse(session_value)
      @current_user ||= User.find_by(id: parsed_session_value["user_id"])

    elsif cookies_key = cookies.signed[:cookies_key]
      cookies_value = $redis.get(cookies_key)

      return reset_session unless cookies_value
      parsed_cookies_value = JSON.parse(cookies_value)
      user = User.find_by(id: parsed_cookies_value["user_id"])

      if user && user.authenticated?(parsed_cookies_value["remember_token"])
        login user
        @current_user = user
      end
    end
  end

  def logout
    forget current_user
    reset_session
    @current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:cookies_key)
  end

  def logged_in?
    current_user.present?
  end

  def reject_logged_in_user
    render json: { errors: [ { message:  "Already logged in" } ] }, status: :forbidden if logged_in?
  end

  def restrict_to_logged_in_user
    render json: { errors: [ message: "Not logged in" ] }, status: :unauthorized unless logged_in?
  end
end
