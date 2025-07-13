# frozen_string_literal: true

class Auth::VerificationsController < ApplicationController
  before_action :reject_logged_in_user

  def create
    auth_request = AuthRequest.find_by(auth_verification_params)

    if auth_request && !auth_request.expired?
      user = User.find_by(email: auth_request.email)

      if user
        login user
        remember user

        auth_request.destroy!

        Rails.logger.info("User #{user.inspect} logged in via auth request with token #{auth_request.token}.")

        render json: user, serializer: UserSerializer, root: :auth_verification, status: :created
      else
        session[:auth_request_id] = auth_request.id
        render body: nil, status: :no_content
      end
    else
      render json: error_json([ "認証コードが正しくないか、有効期限が切れています。" ]), status: :unprocessable_entity
    end
  end

  private

    def auth_verification_params
      params.require(:auth_verification).permit(:token)
    end
end
