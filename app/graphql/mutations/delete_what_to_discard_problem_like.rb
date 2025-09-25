# frozen_string_literal: true

module Mutations
  class DeleteWhatToDiscardProblemLike < BaseMutation
    description "Delete a like for what to discard problem"

    argument :what_to_discard_problem_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(what_to_discard_problem_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      like = context[:current_user].created_likes.find_by(
        likable_type: "WhatToDiscardProblem",
        likable_id: what_to_discard_problem_id
      )

      if like.nil?
        { success: false, errors: [ "Like not found" ] }
      elsif like.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: like.errors.full_messages }
      end
    end
  end
end