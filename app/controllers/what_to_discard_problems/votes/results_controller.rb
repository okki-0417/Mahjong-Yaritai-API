# frozen_string_literal: true

class WhatToDiscardProblems::Votes::ResultsController < ApplicationController
  def show
    problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
    each_tile_vote_count = problem.votes.pluck(:tile_id).tally
    my_vote_tile_id = current_user&.created_what_to_discard_problem_votes
      &.find_by(what_to_discard_problem_id: params[:what_to_discard_problem_id])
      &.tile_id

    results = problem.hand_ids.map do |tile_id|
      {
        tile_id:,
        count: each_tile_vote_count[tile_id] || 0,
        is_voted_by_me: my_vote_tile_id == tile_id,
      }
    end

    render json: results,
      root: :what_to_discard_problem_vote_result,
      each_serializer: WhatToDiscardProblem::Vote::ResultSerializer,
      status: :ok
  end
end
