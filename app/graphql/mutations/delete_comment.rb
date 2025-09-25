# frozen_string_literal: true

module Mutations
  class DeleteComment < BaseMutation
    description "Delete a comment"

    argument :comment_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(comment_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      comment = context[:current_user].created_comments.find_by(id: comment_id)

      if comment.nil?
        { success: false, errors: [ "Comment not found" ] }
      elsif comment.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: comment.errors.full_messages }
      end
    end
  end
end
