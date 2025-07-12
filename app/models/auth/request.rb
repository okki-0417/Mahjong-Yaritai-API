# frozen_string_literal: true

class Auth::Request < ApplicationRecord
  self.table_name = "auth_requests"
  TOKEN_LENGTH = 6
  EXPIRATION_PERIOD = 15.minutes
  EMAIL_LENGTH = 64

  validates :email, presence: true, length: { maximum: EMAIL_LENGTH }
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
