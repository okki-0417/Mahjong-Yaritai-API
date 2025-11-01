# frozen_string_literal: true

module Authenticatable
  def login(user)
    reset_session
    context[:session][:user_id] = user.id
    context[:session][:remember_user_id] = user.id
    context[:current_user] = user
  end

  def logout
    reset_session
    forget_cookies
    context[:current_user] = nil
  end

  def current_user
    context[:current_user]
  end

  def logged_in?
    current_user.present?
  end

  def require_authentication!
    raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?
  end

  private

  def reset_session
    context[:session].clear
  end

  def forget_cookies
    return unless context[:cookies]

    context[:cookies].delete(:user_id)
    context[:cookies].delete(:remember_token)
  end
end
