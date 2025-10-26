# frozen_string_literal: true

module Resolvers
  module Comments
    class ParentsResolver < BaseResolver
      graphql_name "CommentParentsResolver"

      type Types::CommentType.connection_type, null: false
      description "Get parent comments for a what to discard problem"

      argument :what_to_discard_problem_id, ID, required: true

      def resolve(what_to_discard_problem_id:)
        Comment
          .parents
          .where(commentable_type: "WhatToDiscardProblem", commentable_id: what_to_discard_problem_id)
          .preload(user: :avatar_attachment)
          .order(id: :desc)
      end
    end
  end
end
