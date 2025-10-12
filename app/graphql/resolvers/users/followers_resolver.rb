# frozen_string_literal: true

module Resolvers
  module Users
    class FollowersResolver < BaseResolver
      include Authenticatable

      type Types::UserType.connection_type, null: false
      description "Get users that are following current user"

      def resolve
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        current_user.followers.includes(avatar_attachment: :blob).order("follows.created_at DESC")
      end
    end
  end
end
