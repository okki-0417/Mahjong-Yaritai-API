# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :reject_logged_in_user, only: %i[create]
  before_action :restrict_to_logged_in_user, only: %i[destroy]

  def create
    auth_request = AuthRequest.find_by(id: session[:auth_request_id]&.to_i)

    # formDataで受け取るため、StrongParameter(JSON)を使えない
    create_params = { name: params[:name] }
    create_params[:profile_text] = params[:profile_text] if params[:profile_text].present?
    create_params[:avatar] = params[:avatar] if params[:avatar].present? && params[:avatar] != "undefined"

    user = User.new(
      email: auth_request&.email,
      **create_params,
    )

    if user.save
      login user
      remember user

      auth_request.destroy!

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

  def destroy
    User.destroy(current_user.id)
    head :no_content
  end
end
