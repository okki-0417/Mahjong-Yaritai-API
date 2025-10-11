# frozen_string_literal: true

module Resolvers
  class FollowedUsersResolver < BaseResolver
    type [ Types::UserType ], null: false
    description "Get users that current user is following"

    def resolve
      return [] unless current_user

      current_user.following.includes(avatar_attachment: :blob).order("follows.created_at DESC")
    end
  end
end
