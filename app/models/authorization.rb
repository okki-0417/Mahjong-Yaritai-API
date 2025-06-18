# frozen_string_literal: true

class Authorization < ApplicationRecord
  validates :email, presence: true
  validate :check_email_uniqueness

  EXPIRATION_PERIOD = 15.minutes
  before_create :generate_token

  def expired?
    created_at < EXPIRATION_PERIOD.ago
  end

  private

  def generate_token
    self.token = SecureRandom.random_number(10 ** 6).to_s.rjust(6, "0")
  end

  def check_email_uniqueness
    return unless User.exists?(email:)

    errors.add(:email, :taken)
  end
end
