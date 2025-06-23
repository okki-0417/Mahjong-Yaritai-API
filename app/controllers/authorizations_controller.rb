# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  def create
    authorization = Authorization.find_by(token: token_params[:token])

    if authorization && !authorization.expired?
      session[:authorization_id] = authorization.id

      head :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      authorized: Authorization.exists?(
        id: session[:authorization_id]&.to_i
      ),
    }, status: :ok
  end

  private

  def token_params
    params.require(:authorization).permit(:token)
  end
end
