# frozen_string_literal: true

class Users::FollowersController < ApplicationController
  include CursorPaginationable

  before_action :set_user

  def index
    result = query_with_cursor_pagination(
      @user.followers.select("users.*"),
      cursor: params[:cursor],
      limit: params[:limit] || 20
    )

    render json: {
      users: result[:records].map { |user| UserSerializer.new(user).as_json },
      meta: result[:meta],
    }
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ "ユーザーが見つかりません" ] }, status: :not_found
    end
end
