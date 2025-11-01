# frozen_string_literal: true

module Authenticatable
  def login(user)
    reset_session
    context[:session][:user_id] = user.id
    context[:session][:remember_user_id] = user.id
    context[:current_user] = user
  end

  def logout
    forget_user_from_db
    forget_cookies
    reset_session
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
    # セッションを破棄してセッションIDのcookieも削除
    if context[:session].respond_to?(:destroy)
      context[:session].destroy
    else
      context[:session].clear
    end
  end

  def forget_user_from_db
    return unless current_user

    current_user.forget
  end

  def forget_cookies
    return unless context[:cookies]

    cookie_domain = Rails.env.production? ? ENV.fetch("ETLD_HOST") : "localhost"

    # 設定時と同じdomainを指定して削除
    context[:cookies].delete(:user_id, domain: cookie_domain)
    context[:cookies].delete(:remember_token, domain: cookie_domain)
  end
end
