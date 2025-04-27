# frozen_string_literal: true

class WhatToDiscardProblems::VotesController < WhatToDiscardProblems::BaseController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
    votes = problem.votes
    each_tile_vote_count = votes.pluck(:tile_id).tally

    vote_results = problem.hand_ids.map do |tile_id|
      {
        tile_id:,
        count: each_tile_vote_count[tile_id] || 0,
      }
    end

    render json: { what_to_discard_problem_votes: {
      results: vote_results,
      total_count: problem.votes_count,
    } }, status: :ok
  end

  def create
    vote = current_user.created_what_to_discard_problem_votes.new(what_to_discard_problem_id: params[:what_to_discard_problem_id], **vote_params)

    if vote.save
      problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
      each_tile_vote_count = problem.votes.pluck(:tile_id).tally

      vote_results = problem.hand_ids.map do |tile_id|
        {
          tile_id:,
          count: each_tile_vote_count[tile_id] || 0,
        }
      end

      render json: { what_to_discard_problem_votes: {
        results: vote_results,
        total_count: problem.votes_count,
        current_user_vote: {
          id: vote.id,
          tile_id: vote.tile_id
        }
      } }, status: :created
    else
      render json: validation_error_json(vote), status: :unprocessable_entity
    end
  end

  def destroy
    vote = current_user.created_what_to_discard_problem_votes.find(params[:id])

    if vote.destroy
      problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
      each_tile_vote_count = problem.votes.pluck(:tile_id).tally

      vote_results = problem.hand_ids.map do |tile_id|
        {
          tile_id:,
          count: each_tile_vote_count[tile_id] || 0,
        }
      end

      render json: { what_to_discard_problem_votes: {
        results: vote_results,
        total_count: problem.votes_count,
        current_user_vote: {
          id: nil,
          tile_id: nil,
        }
      } }, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def vote_params
    params.require(:what_to_discard_problem_vote).permit(:tile_id)
  end
end
