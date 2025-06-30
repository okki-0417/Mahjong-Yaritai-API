# frozen_string_literal: true

class WhatToDiscardProblems::VotesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def create
    vote = current_user.created_what_to_discard_problem_votes.new(
      what_to_discard_problem_id: params[:what_to_discard_problem_id],
      **vote_params
    )

    if vote.save
      render json: vote,
        serializer: WhatToDiscardProblem::VoteSerializer,
        root: :what_to_discard_problem_vote,
        status: :created
    else
      render json: validation_error_json(vote), status: :unprocessable_entity
    end
  end

  def destroy
    vote = current_user.created_what_to_discard_problem_votes.find(params[:id])

    vote.destroy!

    render json: {}, status: :no_content
  end

  private

  def vote_params
    params.require(:what_to_discard_problem_vote).permit(:tile_id)
  end
end
