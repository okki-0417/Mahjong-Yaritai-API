# frozen_string_literal: true

class WhatToDiscardProblems::Votes::MyVotesController < WhatToDiscardProblems::BaseController
  def show
    return render json: { my_vote: { id: nil, tile_id: nil } }, status: :ok unless logged_in?

    problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
    current_user_vote = problem.votes.find_by(user_id: current_user&.id)

    render json: { my_vote: { id: current_user_vote&.id, tile_id: current_user_vote&.tile_id } }
  end
end
