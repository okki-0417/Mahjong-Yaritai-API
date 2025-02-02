# frozen_string_literal: true

class User::VerificationForm < BaseForm
  attr_accessor :email

  validate :verify_email_uniqueness

  private

  def verify_email_uniqueness
    user = User.find_by(email:)
    return unless user

    errors.add(:email, :taken)
  end
end
