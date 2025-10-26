# frozen_string_literal: true

module Resolvers
  module WhatToDiscardProblems
    class BookmarksResolver < BaseResolver
      graphql_name "WhatToDiscardProblemBookmarksResolver"

      include Authenticatable

      type Types::WhatToDiscardProblemType.connection_type, null: false
      description "Get bookmarked what to discard problems for current user"

      def resolve
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        context[:current_user].bookmarked_what_to_discard_problems
          .includes(
            :votes,
            :likes,
            :bookmarks,
            user: :avatar_attachment,
          )
          .order(id: :desc)
      end
    end
  end
end
