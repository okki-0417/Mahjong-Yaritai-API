# frozen_string_literal: true

class AuthorizationsController < ApplicationController
  before_action :reject_logged_in_user, only: %i[create]

  def create
    authorization = Authorization.find_by(token_params)

    if authorization && !authorization.expired?
      session[:authorization_id] = authorization.id

      head :ok
    else
      render json: error_json([ "認証に失敗しました" ]), status: :unprocessable_entity
    end
  end

  private

    def token_params
      params.require(:authorization).permit(:token)
    end
end
