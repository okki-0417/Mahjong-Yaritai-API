# frozen_string_literal: true

module Mutations
  class CreateComment < BaseMutation
    description "Create a comment"

    argument :what_to_discard_problem_id, ID, required: true
    argument :content, String, required: true
    argument :parent_comment_id, ID, required: false

    field :comment, Types::CommentType, null: false
    field :errors, [ String ], null: true

    def resolve(what_to_discard_problem_id:, content:, parent_comment_id: nil)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      comment = context[:current_user].created_comments.new(
        commentable_type: "WhatToDiscardProblem",
        commentable_id: what_to_discard_problem_id,
        content: content,
        parent_comment_id: parent_comment_id
      )

      raise GraphQL::ExecutionError, comment.errors.full_messages.join(", ") unless comment.save

        { comment: comment, errors: [] }
    end
  end
end
