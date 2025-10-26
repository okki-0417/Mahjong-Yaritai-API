# frozen_string_literal: true

module Resolvers
  module Comments
    class RepliesResolver < BaseResolver
      graphql_name "CommentRepliesResolver"

      type Types::CommentType.connection_type, null: false
      description "Get replies for a parent comment"

      argument :parent_comment_id, ID, required: true
      argument :commentable_type, String, required: true
      argument :commentable_id, ID, required: true

      def resolve(commentable_type:, commentable_id:, parent_comment_id:)
        commentable = case commentable_type
        when WhatToDiscardProblem.name
          WhatToDiscardProblem.find(commentable_id)
        else
          nil
        end

        Comment
          .where(parent_comment_id:, commentable:)
          .preload(user: :avatar_attachment)
          .order(id: :asc)
      end
    end
  end
end
