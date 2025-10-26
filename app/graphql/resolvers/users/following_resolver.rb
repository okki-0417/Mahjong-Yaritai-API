# frozen_string_literal: true

module Resolvers
  module Users
    class FollowingResolver < BaseResolver
      graphql_name "UserFollowingResolver"

      include Authenticatable

      type Types::UserType.connection_type, null: false
      description "Get users that current user is following"

      def resolve
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        current_user.following.includes(avatar_attachment: :blob).order("follows.created_at DESC")
      end
    end
  end
end
