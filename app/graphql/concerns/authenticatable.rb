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
    context[:current_user] = nil
  end

  def logged_in?
    context[:current_user].present?
  end

  private

    def reset_session
      context[:session].keys.each do |key|
        context[:session].delete(key)
      end
    end
end
