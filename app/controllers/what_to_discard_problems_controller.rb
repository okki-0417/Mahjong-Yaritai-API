# frozen_string_literal: true

class WhatToDiscardProblemsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    problems = WhatToDiscardProblem.preload(:user)
                                   .order(created_at: :desc)
                                   .page(params[:page])
                                   .per(3)

    render json: {
      what_to_discard_problems: {
        data: problems.map do |problem|
                problem.as_json(
                  only: %i[
                    id
                    round
                    turn
                    wind
                    point_east
                    point_west
                    point_south
                    point_north
                    created_at
                    likes_count
                    comments_count
                    votes_count
                    dora_id
                    tsumo_id
                  ],
                  include: {
                    user: { only: %i[id name] },
                  }
                ).merge({
                  hand_ids: problem.hand_ids,
                })
              end,
        pagination: {
          next_page: problems.next_page,
        }
      }
    }
  end

  def create
    problem = current_user.created_what_to_discard_problems.new(problem_params)

    if problem.save
      render json: {
        what_to_discard_problem: {
          data: problem.as_json(
            only: %i[
              id
              round
              turn
              wind
              point_east
              point_west
              point_south
              point_north
              created_at
              likes_count
              comments_count
              votes_count
              dora_id
              tsumo_id
            ],
            include: {
              user: { only: %i[id name] },
            }
            ).merge({
              hand_ids: problem.hand_ids,
            }),
          pagination: {
            next_page: problems.next_page,
          }
        }
      }, status: :created
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
      :point_east,
      :point_south,
      :point_west,
      :point_north,
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
      :tsumo_id
    )
  end
end
