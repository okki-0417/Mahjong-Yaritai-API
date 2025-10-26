# frozen_string_literal: true

module Mutations
  module Users
    class UpdateUser < BaseMutation
      include Authenticatable

      field :user, Types::UserType, null: false

      argument :name, String, required: false
      argument :profile_text, String, required: false
      argument :avatar, Types::UploadType, required: false

      def resolve(name: nil, profile_text: nil, avatar: nil)
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        user = context[:current_user]

        attributes = {}
        attributes[:name] = name if name.present?
        attributes[:profile_text] = profile_text if profile_text.present?

        user.avatar.attach(avatar) if avatar.present?

        if attributes.present?
          unless user.update(attributes)
            user.errors.full_messages.each do |message|
              context.add_error(GraphQL::ExecutionError.new(message))
            end
            return nil
          end
        end

        { user: user.reload }
      end
    end
  end
end
