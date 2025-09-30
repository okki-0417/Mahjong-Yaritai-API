# frozen_string_literal: true

module Mutations
  class VerifyAuth < BaseMutation
    description "Verify authentication token and login user"

    field :success, Boolean, null: false
    field :errors, [ String ], null: false
    field :user, Types::UserType, null: true

    argument :email, String, required: true
    argument :token, String, required: true

    def resolve(email:, token:)
      auth_request = AuthRequest.find_by(email: email, token: token)

      unless auth_request
        return {
          success: false,
          errors: [ "Invalid email or token" ],
          user: nil,
        }
      end

      if auth_request.expired?
        auth_request.destroy
        return {
          success: false,
          errors: [ "Token has expired" ],
          user: nil,
        }
      end

      # ユーザーを検索または作成
      user = User.find_by(email: email)
      if user.nil?
        user = User.create!(email: email, name: email.split("@").first)
      end

      # セッション設定
      context[:session][:user_id] = user.id
      context[:current_user] = user

      # 使用済みtoken削除
      auth_request.destroy

      {
        success: true,
        errors: [],
        user: user,
      }
    rescue StandardError => e
      Rails.logger.error "VerifyAuth mutation error: #{e.message}"
      {
        success: false,
        errors: [ "Authentication failed" ],
        user: nil,
      }
    end
  end
end
