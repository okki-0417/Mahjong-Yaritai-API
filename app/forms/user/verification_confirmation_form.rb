# frozen_string_literal: true

class User::VerificationConfirmationForm < BaseForm
  attr_accessor :params_token
  attr_accessor :session_token

  validates :params_token, presence: true
  validates :session_token, presence: true

  validate :check_confirmation_token_match
  validate :check_temp_user_existence

  def temp_user
    TempUser.find_by(token: session_token)
  end

  private

  def check_confirmation_token_match
    return if params_token == session_token

    errors.add(:params_token, :confirmation_token_mismatch)
  end

  def check_temp_user_existence
    temp_user = TempUser.find_by(token: session_token)
    return if temp_user

    errors.add(:session_token, :temp_user_not_found)
  end
end
