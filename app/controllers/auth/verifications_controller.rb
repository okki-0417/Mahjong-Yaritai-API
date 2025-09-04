# frozen_string_literal: true

class Auth::VerificationsController < ApplicationController
  before_action :reject_logged_in_user

  def create
    auth_request = AuthRequest.find_by(auth_verification_params)

    return render json: validation_error_json(auth_request),
      status: :unprocessable_entity unless auth_request&.within_valid_period?

    if user = auth_request.requested_user
      login user
      remember user

      render json: user, status: :created
    else
      session[:auth_request_id] = auth_request.id

      render body: nil, status: :no_content
    end
  end

  private

    def auth_verification_params
      params.require(:auth_verification).permit(:token)
    end
end
