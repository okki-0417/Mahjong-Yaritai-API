# frozen_string_literal: true

class WhatToDiscardProblems::VotesController < WhatToDiscardProblems::BaseController
  before_action :restrict_to_logged_in_user, only: %i[create]
  def create
    vote = current_user.created_what_to_discard_problem_votes.new(what_to_discard_problem_id: params[:what_to_discard_problem_id], **vote_params)

    if vote.save
      render json: { what_to_discard_problem_vote: vote.as_json(
        include: {
          tile: { only: %i[name] }
        }
      ) }, status: :created
    else
      render json: validation_error_json(vote), status: :unprocessable_entity
    end
  end

  private

  def vote_params
    params.require(:what_to_discard_problem_vote).permit(:tile_id)
  end
end
