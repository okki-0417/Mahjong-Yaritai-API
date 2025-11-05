# frozen_string_literal: true

module Mutations
  module Users
    class CreateUser < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: false

      argument :name, String, required: true
      argument :profile_text, String, required: false
      argument :avatar, Types::UploadType, required: false

      def resolve(name:, profile_text: nil, avatar: nil)
        raise GraphQL::ExecutionError, "既にログインしています" if logged_in?

        auth_request_id = session[:auth_request_id]
        raise GraphQL::ExecutionError, "先に認証してください" unless auth_request_id

        auth_request = AuthRequest.find_by(id: auth_request_id)
        raise GraphQL::ExecutionError, "認証情報が見つかりません" unless auth_request

        user = User.new(name:, email: auth_request.email, profile_text:)

        user.avatar.attach(avatar) if avatar.present?

        if user.save
          session.delete(:auth_request_id)
          login user

          { user: }
        else
          user.errors.full_messages.each do |message|
            context.add_error(GraphQL::ExecutionError.new(message))
          end
          nil
        end
      end
    end
  end
end
