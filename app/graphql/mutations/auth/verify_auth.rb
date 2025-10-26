# frozen_string_literal: true

module Mutations
  module Auth
    class VerifyAuth < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: true

      argument :token, String, required: true

      def resolve(token:)
        raise GraphQL::ExecutionError, "既にログインしています" if logged_in?

        email = context[:session][:pending_auth_email]
        context[:session].delete(:pending_auth_email)
        raise GraphQL::ExecutionError, "認証リクエストが見つかりません" unless email

        auth_request = AuthRequest.find_by(email:, token:)
        raise GraphQL::ExecutionError, "トークンが無効です" unless auth_request

        if auth_request.expired?
          auth_request.destroy
          raise GraphQL::ExecutionError, "トークンの有効期限が切れています"
        end

        if user = User.find_by(email:)
          login(user)
          { user: }
        else
          context[:session][:auth_request_id] = auth_request.id
          { user: nil }
        end
      end
    end
  end
end
