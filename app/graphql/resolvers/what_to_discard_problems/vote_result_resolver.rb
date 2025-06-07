# frozen_string_literal: true

module Resolvers::WhatToDiscardProblems
  class VoteResultResolver < Resolvers::BaseResolver
    type [Types::WhatToDiscardProblem::VoteResultType], null: false

    argument :what_to_discard_problem_id, Int, required: true

    def resolve(what_to_discard_problem_id:)
      problem = WhatToDiscardProblem.find(what_to_discard_problem_id)
      votes = problem.votes
      each_tile_vote_count = votes.pluck(:tile_id).tally

      problem.hand_ids.map do |tile_id|
        {
          tile_id:,
          count: each_tile_vote_count[tile_id] || 0,
        }
      end
    end
  end
end
