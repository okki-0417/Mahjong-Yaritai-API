# frozen_string_literal: true

module Mutations
  module Users
    class CreateUser < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: false

      argument :name, String, required: true
      argument :email, String, required: true
      argument :profile_text, String, required: false
      argument :avatar, Types::UploadType, required: false

      def resolve(name:, email:, profile_text: nil, avatar: nil)
        raise GraphQL::ExecutionError, "既にログインしています" if logged_in?

        auth_request_id = context[:session][:auth_request_id]
        raise GraphQL::ExecutionError, "先に認証してください" if auth_request_id.blank?

        auth_request = AuthRequest.find_by(id: auth_request_id, email:)
        raise GraphQL::ExecutionError, "認証が切れています" if auth_request.expired?

        user = User.new(name:, email:, profile_text:)

        user.avatar.attach(avatar) if avatar.present?

        if user.save
          login user
          context[:session].delete(:auth_request_id)

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
