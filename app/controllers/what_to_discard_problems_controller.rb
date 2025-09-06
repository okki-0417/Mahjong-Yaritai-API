# frozen_string_literal: true

class WhatToDiscardProblemsController < ApplicationController
  include CursorPaginationable

  before_action :restrict_to_logged_in_user, only: %i[create update destroy]

  def index
    data = query_with_cursor_pagination(
      WhatToDiscardProblem.preload(user: :avatar_attachment),
      cursor: params[:cursor],
      limit: params[:limit],
    )

    problems = data[:records]
    meta = data[:meta]

    render json: problems,
      root: :what_to_discard_problems,
      meta:,
      status: :ok
  end

  def create
    problem = current_user.created_what_to_discard_problems.new(problem_params)

    if problem.save
      render json: problem,
        root: :what_to_discard_problem,
        status: :created
    else
      render json: validation_error_json(problem), status: :unprocessable_entity
    end
  end

  def update
    problem = current_user.created_what_to_discard_problems.find(params[:id])

    if problem.update(problem_params)
      render json: problem,
        root: :what_to_discard_problem,
        status: :ok
    else
      render json: validation_error_json(problem), status: :unprocessable_entity
    end
  end

  def destroy
    problem = current_user.created_what_to_discard_problems.find(params[:id])

    if problem.destroy
      render json: {}, status: :no_content
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

    def problem_params
      params.require(:what_to_discard_problem).permit(
        :round,
        :turn,
        :wind,
        :dora_id,
        :points,
        :hand1_id,
        :hand2_id,
        :hand3_id,
        :hand4_id,
        :hand5_id,
        :hand6_id,
        :hand7_id,
        :hand8_id,
        :hand9_id,
        :hand10_id,
        :hand11_id,
        :hand12_id,
        :hand13_id,
        :tsumo_id,
        :description,
      )
    end
end
