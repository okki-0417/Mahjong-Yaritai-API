# frozen_string_literal: true

module Resolvers
  class FollowersResolver < BaseResolver
    type [ Types::UserType ], null: false
    description "Get users that are following current user"

    def resolve
      return [] unless current_user

      current_user.followers.includes(avatar_attachment: :blob).order("follows.created_at DESC")
    end
  end
end
