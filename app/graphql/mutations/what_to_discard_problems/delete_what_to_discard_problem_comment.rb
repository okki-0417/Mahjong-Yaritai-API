# frozen_string_literal: true

module Mutations
  module WhatToDiscardProblems
    class DeleteWhatToDiscardProblemComment < BaseMutation
      include Authenticatable

      field :success, Boolean, null: false

      argument :comment_id, ID, required: true

      def resolve(comment_id:)
        raise GraphQL::ExecutionError, "ログインしてください" unless logged_in?

        comment = context[:current_user].created_comments.find(comment_id)

        if comment.destroy
          { success: true }
        else
          comment.errors.full_messages.each do |message|
            context.add_error(GraphQL::ExecutionError.new(message))
          end
          nil
        end
      end
    end
  end
end
