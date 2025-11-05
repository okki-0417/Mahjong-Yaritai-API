# frozen_string_literal: true

module Resolvers
  module WhatToDiscardProblems
    class ListWhatToDiscardProblems < BaseResolver
      type Types::WhatToDiscardProblemType.connection_type, null: false

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
