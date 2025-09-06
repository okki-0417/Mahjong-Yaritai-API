# frozen_string_literal: true

class WhatToDiscardProblems::Votes::MyVotesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def show
    my_vote = WhatToDiscardProblem::Vote.find_by(
      what_to_discard_problem_id: params[:what_to_discard_problem_id],
      user_id: current_user&.id,
    )

    render json: my_vote,
      root: :what_to_discard_problem_my_vote,
      status: :ok
  end

  def create
    vote = current_user.created_what_to_discard_problem_votes.new(
      what_to_discard_problem_id: params[:what_to_discard_problem_id],
      **vote_params
    )

    if vote.save
      render json: vote,
        root: :what_to_discard_problem_my_vote,
        status: :created
    else
      render json: validation_error_json(vote), status: :unprocessable_entity
    end
  end

  def destroy
    vote = current_user.created_what_to_discard_problem_votes
      .find_by!(what_to_discard_problem_id: params[:what_to_discard_problem_id])

    vote.destroy!

    head :no_content
  end

  private

    def vote_params
      params.require(:what_to_discard_problem_my_vote).permit(:tile_id)
    end
end
