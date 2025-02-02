# frozen_string_literal: true

class Users::VerificationConfirmationsController < ApplicationController
  def show
    return head :unprocessable_entity if params[:token].blank? || session[:token].blank?

    form = User::VerificationConfirmationForm.new(
      params_token: params[:token],
      session_token: session[:token],
    )

    if form.valid?
      session[:email] = form.temp_user.email
      session[:verification_session_expired_at] = form.temp_user.expired_at

      session.delete(:token)

      head :no_content
    else
      return render json: {}, status: :unprocessable_entity
    end
  end
end
