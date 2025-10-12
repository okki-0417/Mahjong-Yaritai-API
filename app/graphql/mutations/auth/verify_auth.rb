# frozen_string_literal: true

module Mutations
  module Auth
    class VerifyAuth < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: true

      argument :email, String, required: true
      argument :token, String, required: true

      def resolve(email:, token:)
        raise GraphQL::ExecutionError, "既にログインしています" if logged_in?

        auth_request = AuthRequest.find_by(email:, token:)

        raise GraphQL::ExecutionError, "メールアドレスまたはトークンが無効です" unless auth_request

        if auth_request.expired?
          auth_request.destroy
          raise GraphQL::ExecutionError, "トークンの有効期限が切れています"
        end

        user = User.find_by(email:)

        auth_request.destroy

        if user.present?
          login(user)
          { user: }
        else
          { user: nil }
        end
      end
    end
  end
end
