# frozen_string_literal: true

module Resolvers
  module WhatToDiscardProblems
    class VoteResultsResolver < BaseResolver
      graphql_name "WhatToDiscardProblemVoteResultsResolver"

      type [ Types::WhatToDiscardProblemVoteResultType ], null: false
      description "Get vote results for a what to discard problem"

      argument :what_to_discard_problem_id, ID, required: true

      def resolve(what_to_discard_problem_id:)
        problem = WhatToDiscardProblem.find(what_to_discard_problem_id)

        # Group votes by tile_id and count them
        vote_counts = problem.votes.group(:tile_id).count
        total_votes = vote_counts.values.sum

        # Build result array with tile_id, count, and percentage
        vote_counts.map do |tile_id, count|
          percentage = total_votes > 0 ? (count.to_f / total_votes * 100).round(1) : 0.0
          {
            tile_id: tile_id,
            count: count,
            percentage:,
          }
        end
      end
    end
  end
end
