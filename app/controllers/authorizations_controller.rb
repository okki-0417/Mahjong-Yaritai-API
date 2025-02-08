# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  def create
    authorization = Authorization.find_by(token: params[:token])

    if authorization && !authorization.expired?
      session[:authorization_id] = authorization.id

      head :no_content
    else
      return render json: {}, status: :unprocessable_entity
    end
  end
end
