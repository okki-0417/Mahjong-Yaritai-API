# frozen_string_literal: true

class Authorization < ApplicationRecord
  TOKEN_LENGTH = 6
  EXPIRATION_PERIOD = 15.minutes
  EMAIL_LENGTH = 64

  validates :email, presence: true, length: { maximum: EMAIL_LENGTH }
  validates :token, presence: true
  validate :check_email_uniqueness

  before_validation :generate_token, on: :create

  def expired?
    created_at < EXPIRATION_PERIOD.ago
  end

  private

  def generate_token
    self.token = SecureRandom.random_number(10 ** TOKEN_LENGTH).to_s.rjust(TOKEN_LENGTH, "0")
  end

  def check_email_uniqueness
    return unless User.exists?(email:)

    errors.add(:email, :taken)
  end
end
