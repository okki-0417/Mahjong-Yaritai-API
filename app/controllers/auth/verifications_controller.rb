# frozen_string_literal: true

class Auth::VerificationsController < ApplicationController
  before_action :reject_logged_in_user

  def create
    form = Auth::VerificationForm.new(auth_verification_params)

    return render json: validation_error_json(form),
        status: :unprocessable_entity unless form.valid?

    if user = form.user
      login user
      remember user

      render json: user, status: :created
    else
      session[:auth_request_id] = form.auth_request.id

      render body: nil, status: :no_content
    end
  end

  private

    def auth_verification_params
      params.require(:auth_verification).permit(:token)
    end
end
