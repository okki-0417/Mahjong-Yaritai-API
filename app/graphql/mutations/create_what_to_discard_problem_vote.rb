# frozen_string_literal: true

module Mutations
  class CreateWhatToDiscardProblemVote < BaseMutation
    description "Create a vote for what to discard problem"

    argument :what_to_discard_problem_id, ID, required: true
    argument :tile_id, ID, required: true

    field :vote, Types::WhatToDiscardProblemVoteType, null: false
    field :errors, [ String ], null: true

    def resolve(what_to_discard_problem_id:, tile_id:)
      raise GraphQL::ExecutionError, "User must be logged in" unless context[:current_user]

      vote = context[:current_user].created_what_to_discard_problem_votes.new(
        what_to_discard_problem_id: what_to_discard_problem_id,
        tile_id: tile_id
      )

      raise GraphQL::ExecutionError, vote.errors.full_messages.join(", ") unless vote.save

        { vote: vote, errors: [] }
    end
  end
end
