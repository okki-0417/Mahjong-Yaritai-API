# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    class CreateWhatToDiscardProblemBookmark < BaseMutation
      include Authenticatable

      field :bookmark, Types::BookmarkType, null: false

      argument :problem_id, ID, required: true

      def resolve(problem_id:)
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        problem = WhatToDiscardProblem.find(problem_id)

        bookmark = context[:current_user].created_bookmarks.new(
          bookmarkable: problem
        )

        if bookmark.save
          { bookmark: }
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
