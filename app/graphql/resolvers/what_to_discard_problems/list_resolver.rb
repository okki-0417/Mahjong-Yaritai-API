# frozen_string_literal: true

module Resolvers
  module WhatToDiscardProblems
    class ListResolver < BaseResolver
      graphql_name "WhatToDiscardProblemListResolver"

      type Types::WhatToDiscardProblemType.connection_type, null: false
      description "Get all what to discard problems"

      def resolve
        WhatToDiscardProblem
          .preload(
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
