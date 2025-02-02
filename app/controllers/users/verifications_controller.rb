# frozen_string_literal: true

class Users::VerificationsController < ApplicationController
  def create
    verification_form = User::VerificationForm.new(user_registration_params)
    return render json: { errors: verification_form.errors.full_messages.map{ |message| { message: }} }, status: :unprocessable_entity unless verification_form.valid?

    @token = SecureRandom.urlsafe_base64

    temp_user = TempUser.new(
      email: user_registration_params[:email],
      token: @token,
      expired_at: Time.current,
    )

    if temp_user.save
      UserMailer.registration_email(
        email: temp_user.email,
        token: @token,
      ).deliver_now

      session[:token] = @token
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def user_registration_params
    params.require(:user_verification).permit(:email)
  end
end
