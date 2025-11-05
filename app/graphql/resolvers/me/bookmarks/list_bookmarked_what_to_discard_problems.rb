# frozen_string_literal: true

module Resolvers
  module Me
    module Bookmarks
      module WhatToDiscardProblems
        class ListBookmarkedWhatToDiscardProblems < BaseResolver
          include Authenticatable

          type Types::WhatToDiscardProblemType.connection_type, null: false

          def resolve
            return WhatToDiscardProblem.none unless logged_in?

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
  end
end
