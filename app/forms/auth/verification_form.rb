# frozen_string_literal: true

class Auth::VerificationForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :token, :string

  validates :token, presence: true
  validates :auth_request, presence: "不正な認証コードです。"
  validate :must_in_expiration

  def user
    @user ||= User.find_by(email: auth_request&.email)
  end

  def auth_request
    @auth_request ||= AuthRequest.find_by(token:)
  end

  private

    def must_in_expiration
      return if auth_request.blank?

      return unless auth_request.expired?

      errors.add(:base, "認証リクエストの有効期限が切れています。")
    end
end
