# frozen_string_literal: true

class WhatToDiscardProblemsController < ApplicationController
  include CursorPaginationable

  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    base_relation = WhatToDiscardProblem.preload(user: :avatar_attachment)
      .eager_load(
        :dora,
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
        :tsumo)

    result = cursor_paginate(
      base_relation,
      cursor: params[:cursor],
      limit: params[:limit]
    )

    problems = result[:records]
    problem_ids = problems.map(&:id)

    problem_ids_liked_by_me = if logged_in?
      current_user.created_likes
        .where(likable_type: WhatToDiscardProblem.name, likable_id: problem_ids)
        .pluck(:likable_id)
    else
      []
    end

    votes_by_me = if logged_in?
      current_user.created_what_to_discard_problem_votes
        .where(what_to_discard_problem_id: problem_ids)
        .pluck(:what_to_discard_problem_id, :tile_id)
        .to_h
    else
      {}
    end

    render json: problems,
      each_serializer: WhatToDiscardProblemSerializer,
      root: :what_to_discard_problems,
      scope: { problem_ids_liked_by_me:, votes_by_me: },
      meta: result[:meta],
      status: :ok
  end

  def create
    problem = current_user.created_what_to_discard_problems.new
    Rails.logger.info "problem:#{problem.inspect}"
    Rails.logger.info "params:#{params}"
    Rails.logger.info "problem_params:#{problem_params}"
    Rails.logger.info "tile_all:#{Tile.all}}"

    if problem.save
      render json: problem,
        serializer: WhatToDiscardProblemSerializer,
        root: :what_to_discard_problem,
        scope: { problem_ids_liked_by_me: [], votes_by_me: {} },
        status: :created
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
