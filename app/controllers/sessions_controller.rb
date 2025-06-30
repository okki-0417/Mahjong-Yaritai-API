# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :reject_logged_in_user, only: %i[create]
  before_action :restrict_to_logged_in_user, only: %i[destroy]

  def create
    user = User.find_by!(email: session_params[:email])

    if user.authenticate(session_params[:password])
      login user
      remember user

      render json: current_user,
        serializer: SessionSerializer,
        root: :session,
        status: :created
    else
      render json: { errors: [ { message: "Not authorized" } ] }, status: :unprocessable_entity
    end
  end

  def show
    render json: current_user, serializer: SessionSerializer, status: :ok
  end

  def destroy
    logout

    head :no_content
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
