# frozen_string_literal: true

class Users::FollowsController < ApplicationController
  include Authenticatable

  before_action :restrict_to_logged_in_user
  before_action :set_user

  def create
    @follow = current_user.active_follows.build(followee: @user)

    if @follow.save
      render json: { message: "フォローしました" }, status: :created
    else
      render json: { errors: @follow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @follow = current_user.active_follows.find_by(followee: @user)

    if @follow&.destroy
      render json: { message: "フォローを解除しました" }, status: :ok
    else
      render json: { errors: [ "フォロー関係が見つかりません" ] }, status: :not_found
    end
  end

  private

    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ "ユーザーが見つかりません" ] }, status: :not_found
    end
end
