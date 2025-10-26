# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    module Bookmarks
      class Delete < BaseMutation
        graphql_name "DeleteWhatToDiscardProblemBookmark"

        include Authenticatable

        field :id, ID, null: false

        argument :problem_id, ID, required: true

        def resolve(problem_id:)
          raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

          problem = WhatToDiscardProblem.find(problem_id)
          bookmark = context[:current_user].created_bookmarks.find_by!(bookmarkable: problem)
          bookmark_id = bookmark.id

          if bookmark.destroy
            { id: bookmark_id }
          else
            bookmark.errors.full_messages.each do |message|
              context.add_error(GraphQL::ExecutionError.new(message))
            end
            nil
          end
        end
      end
    end
  end
end
