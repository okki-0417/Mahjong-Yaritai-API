# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[update destroy]

  def create
    authorization = Authorization.find_by(id: session[:authorization_id]&.to_i)

    user = User.new(
      email: authorization&.email,
      **user_params,
    )

    if user.save
      login(user)
      remember(user)

      render json: { user: { id: user.id, name: user.name } }, status: :created
    else
      render json: { errors: user.errors.full_messages.map { |message|  { message: } } }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])

    render json: user, serializer: UserSerializer, status: :ok
  end

  def update
    if current_user.update(user_update_params)
      render json: current_user, serializer: UserSerializer, status: :ok
    else
      render validation_error_json(current_user), status: :unprocessable_entity
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

  def user_update_params
    params.require(:user).permit(:name, :avatar)
  end
end
