# frozen_string_literal: true

class AuthorizationSessionsController < ApplicationController
  def create
    authorization = Authorization.new(authorization_session_params)

    if authorization.save
      UserMailer.registration_email(
        email: authorization.email,
        token: authorization.token
      ).deliver_now

      head :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def authorization_session_params
    params.require(:authorization_session).permit(:email)
  end
end
