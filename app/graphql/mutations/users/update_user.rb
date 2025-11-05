# frozen_string_literal: true

module Mutations
  module Users
    class UpdateUser < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: false

      argument :name, String, required: true
      argument :profile_text, String, required: true
      argument :avatar, Types::UploadType, required: false

      def resolve(name:, profile_text:, avatar: nil)
        require_authentication!

        current_user.avatar.attach(avatar) if avatar.present?

        if current_user.update(name:, profile_text:)
          { user: current_user }
        else
          current_user.errors.full_messages.each do |message|
            context.add_error(GraphQL::ExecutionError.new(message))
          end
          nil
        end
      end
    end
  end
end
