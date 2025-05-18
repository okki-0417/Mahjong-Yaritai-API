# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  def create
    authorization = Authorization.find_by(token: token_params[:token])

    if authorization && !authorization.expired?
      session[:authorization_id] = authorization.id

      head :ok
    else
      return render json: {}, status: :unprocessable_entity
    end
  end

  def show
    authorization = Authorization.find_by(id: session[:authorization_id]&.to_i)

    render json: { authorized: authorization.present? }, status: :ok
  end

  private

  def token_params
    params.require(:authorization).permit(:token)
  end
end
