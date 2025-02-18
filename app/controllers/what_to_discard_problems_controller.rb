# frozen_string_literal: true

class WhatToDiscardProblemsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: [ :create ]

  def index
    problems = WhatToDiscardProblem.all
                                   .preload(:user)
                                   .order(created_at: :desc)
                                   .limit(10)

    render json: {
      what_to_discard_problems: problems.map do |problem|
        problem.as_json(
          include: {
            user: { only: [:id, :name] }
          }
        ).merge({
          likes: {
            what_to_discard_problem_id: problem.id,
            count: problem.likes.length,
            current_user_like_id: problem.likes.find_by(user_id: current_user&.id)&.id,
          }
        })
      end
    }
  end

  def create
    problem = current_user.created_what_to_discard_problems.new(problem_params)

    if problem.save
      render json: { what_to_discard_problem: problem }, status: :created
    else
      render json: validation_error_json(problem), status: :unprocessable_entity
    end
  end

  def show
    problem = WhatToDiscardProblem.find(params[:id])

    render json: { what_to_discard_problem: problem }, status: :ok
  end

  private

  def problem_params
    params.require(:what_to_discard_problem).permit(
      :round,
      :turn,
      :wind,
      :dora,
      :point_east,
      :point_south,
      :point_west,
      :point_north,
      :hand1,
      :hand2,
      :hand3,
      :hand4,
      :hand5,
      :hand6,
      :hand7,
      :hand8,
      :hand9,
      :hand10,
      :hand11,
      :hand12,
      :hand13,
      :tsumo
    )
  end
end
