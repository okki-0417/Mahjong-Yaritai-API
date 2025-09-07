# frozen_string_literal: true

class WhatToDiscardProblems::Votes::ResultsController < ApplicationController
  def show
    problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
    each_tile_vote_count = problem.votes.pluck(:tile_id).tally

    results = problem.hand_ids.uniq.map do |tile_id|
      {
        tile_id:,
        count: each_tile_vote_count[tile_id] || 0,
      }
    end

    render json: results,
      root: :what_to_discard_problem_vote_result,
      each_serializer: WhatToDiscardProblem::Vote::ResultSerializer,
      status: :ok
  end
end
