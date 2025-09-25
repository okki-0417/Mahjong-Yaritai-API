# frozen_string_literal: true

module Mutations
  class CreateWhatToDiscardProblemLike < BaseMutation
    description "Create a like for what to discard problem"

    argument :what_to_discard_problem_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(what_to_discard_problem_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      like = context[:current_user].created_likes.new(
        likable_type: "WhatToDiscardProblem",
        likable_id: what_to_discard_problem_id
      )

      if like.save
        { success: true, errors: [] }
      else
        raise GraphQL::ExecutionError, like.errors.full_messages.join(", ")
      end
    end
  end
end