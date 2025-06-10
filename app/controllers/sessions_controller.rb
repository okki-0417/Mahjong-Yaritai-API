# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :reject_logged_in_user, only: [ :create ]
  before_action :restrict_to_logged_in_user, only: [ :destroy ]

  def create
    user = User.find_by(email: session_params[:email])

    if user && user.authenticate(session_params[:password])
      login user
      remember user

      render json: { session: {
          is_logged_in: logged_in?,
          user_id: current_user.id
        } }, status: :created
    else
      render json: { errors: [ { message: "Not authorized" } ] }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      session: {
        is_logged_in: logged_in?,
        user_id: current_user&.id
      }
    }, status: :ok
  end

  def destroy
    if logged_in?
      logout
      head :no_content
    else
      render json: { errors: [ { message: "Failed to logout" } ] }, status: :bad_request
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
