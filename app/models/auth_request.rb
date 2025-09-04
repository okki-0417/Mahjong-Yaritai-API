# frozen_string_literal: true

class AuthRequest < ApplicationRecord
  TOKEN_LENGTH = 6
  EXPIRATION_PERIOD = 15.minutes

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true
  validates :expired_at, presence: true

  before_validation :generate_token, on: :create
  before_validation :set_expired_at, on: :create

  def expired?
    expired_at < Time.current
  end

  private

    def generate_token
      self.token = SecureRandom.random_number(10**TOKEN_LENGTH).to_s.rjust(TOKEN_LENGTH, "0")
    end

    def set_expired_at
      self.expired_at = EXPIRATION_PERIOD.from_now
    end
end
