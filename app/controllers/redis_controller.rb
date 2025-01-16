# frozen_string_literal: true

class RedisController < ApplicationController
  def show
    # return render json: { "a": "こんにちは"}
    # return render json: { cookies: cookies[:remember_token] }

    $redis.set(:session, {
      user_id: current_user.id
    })

    $redis.set(:cookies, {
      cookies: {
        user_id: current_user.id,
        remember_token: cookies[:remember_token]
      }
    })

    auth = {
      session: $redis.get(:session),
      cookies: $redis.get(:cookies)
    }

    render json: {
        auth:
      # session: {
      #   user_id: current_user.id,
      # },
      # cookies: {
      #   user_id: current_user.id,
      #   remember_token: cookies[:remember_token]
      # }
    }

    # $redis.set("hello_sessions", session)
    # $redis.set("hello_cookies", cookies)

    # reset_session
    # cookies.delete(:user_id)
    # cookies.delete(:remember_token)

    # session[:user_id] = "hello_sessions"
    # session[:remember_token] = "hello_cookies"
  end

  def edit
  end
end
