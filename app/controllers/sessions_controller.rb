# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :reject_logged_in_user, only: [ :create ]
  before_action :restrict_to_logged_in_user, only: [ :destroy ]

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      login user
      remember user
      render json: { user: user }, status: :created
    else
      render json: { errors: [ { message: "Not authorized" } ] }, status: :unprocessable_entity
    end
  end

  def destroy
    if logged_in?
      logout
      head :no_content
    else
      render json: { errors: [ { message: "Failed to logout" } ] }, status: :bad_request
    end
  end

  def state
    if logged_in?
      render json: { auth: true }, status: :ok
    else
      render json: { auth: false }, status: :ok
    end
  end
end
