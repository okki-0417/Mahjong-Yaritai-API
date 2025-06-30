# frozen_string_literal: true

class User < ApplicationRecord
  USER_NAME_LENGTH = 20
  validates :name, presence: true, length: { maximum: USER_NAME_LENGTH }
  EMAIL_REGEXP = /\A[a-zA-Z0-9.!\#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEXP }

  has_secure_password

  has_one_attached :avatar
  has_many :created_what_to_discard_problems, class_name: :WhatToDiscardProblem, dependent: :destroy
  has_many :created_comments, class_name: :Comment, dependent: :destroy
  has_many :created_likes, class_name: :Like, dependent: :destroy
  has_many :created_what_to_discard_problem_votes, class_name: "WhatToDiscardProblem::Vote", dependent: :destroy

  attr_accessor :remember_token

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost:)
  end

  def self.new_token
    SecureRandom.urlsafe_base64(64)
  end
end
