# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :reject_logged_in_user, only: [ :create ]
  before_action :restrict_to_logged_in_user, only: [ :index, :show, :update, :destroy ]

  def index
    users = User.all
    render json: { users: }, status: :ok
  end

  def create
    user = User.new(user_params)

    if user.save
      login user
      remember user
      render json: { user: }, status: :created
    else
      render json: { errors: user.errors.full_messages.map { |message| { message: } } }, status: :unprocessable_entity
    end
  end

  def show
    render json: { user: current_user, avatar: current_user&.avatar }, status: :ok
  end

  def update
    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      render json: { errors: current_user.errors.full_messages.map{ |message|  { message: } } }, status: :unprocessable_entity
    end
  end

  def destroy
    User.destroy(current_user.id)
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
