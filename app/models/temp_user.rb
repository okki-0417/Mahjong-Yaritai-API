# frozen_string_literal: true

class TempUser < ApplicationRecord
  validates :email, presence: true
  validates :token, presence: true
  validates :expired_at, presence: true
end
