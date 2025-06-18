# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  def create
    authorization = Authorization.find_by(token: token_params[:token])

    if authorization && !authorization.expired?
      Rails.logger.info("authorization: #{authorization}")

      session[:authorization_id] = authorization.id
      Rails.logger.info("session[:authorization_id]: #{session[:authorization_id]}")

      head :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def show
    Rails.logger.info("session[:authorization_id]: #{session[:authorization_id]}")
    Rails.logger.info("authorized?: #{Authorization.exists?(id: session[:authorization_id]&.to_i)}")

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
