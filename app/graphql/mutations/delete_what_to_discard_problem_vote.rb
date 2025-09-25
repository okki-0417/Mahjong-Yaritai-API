# frozen_string_literal: true

module Mutations
  class DeleteWhatToDiscardProblemVote < BaseMutation
    description "Delete a vote for what to discard problem"

    argument :what_to_discard_problem_id, ID, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: true

    def resolve(what_to_discard_problem_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      vote = context[:current_user].created_what_to_discard_problem_votes
        .find_by(what_to_discard_problem_id: what_to_discard_problem_id)

      if vote.nil?
        { success: false, errors: [ "Vote not found" ] }
      elsif vote.destroy
        { success: true, errors: nil }
      else
        { success: false, errors: vote.errors.full_messages }
      end
    end
  end
end