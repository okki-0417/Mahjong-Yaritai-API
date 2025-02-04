# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :restrict_to_logged_in_user, only: [ :index, :show, :update, :destroy ]

  def index
    users = User.all
    render json: { users: }, status: :ok
  end

  def create
    authorization_id = redis_get(session[:authorization_id_key])
    authorization = Authorization.find_by(id: authorization_id&.to_i)

    user = User.new(
      email: authorization&.email,
      **user_params,
    )

    if user.save
      session.delete(:authorization_id_key)
      render json: { user: { id: user.id, name: user.name } }, status: :created
    else
      render json: { errors: user.errors.full_messages.map{ |message|  { message: } } }, status: :unprocessable_entity
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
