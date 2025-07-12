# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :reject_logged_in_user, only: %i[create]
  before_action :restrict_to_logged_in_user, only: %i[update destroy]

  def create
    auth_request = Auth::Request.find_by(id: session[:auth_request_id]&.to_i)

    user = User.new(
      email: auth_request&.email,
      **user_params,
    )

    if user.save
      login(user)
      remember(user)

      render json: user, serializer: UserSerializer, root: :user, status: :created
    else
      render json: validation_error_json(user), status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])

    render json: user,
      serializer: UserSerializer,
      root: :user,
      status: :ok
  end

  def update
    # formDataで受け取るため、StrongParameter(JSON)を使えない
    update_params = { name: params[:name] }
    update_params[:avatar] = params[:avatar] if params[:avatar].present? && params[:avatar] != "undefined"

    if current_user.update(update_params)
      render json: current_user,
        serializer: UserSerializer,
        root: :user,
        status: :ok
    else
      render json: validation_error_json(current_user), status: :unprocessable_entity
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
