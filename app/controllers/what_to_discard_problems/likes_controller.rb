# frozen_string_literal: true

class WhatToDiscardProblems::LikesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def create
    like = current_user.created_likes.new(
      likable_type: WhatToDiscardProblem.name,
      likable_id: params[:what_to_discard_problem_id]
    )

    if like.save
      render json: like,
        serializer: LikeSerializer,
        root: :what_to_discard_problem_like,
        status: :created
    else
      render json: validation_error_json(like), status: :unprocessable_entity
    end
  end

  def destroy
    like = current_user.created_likes.find(params[:id])

    like.destroy

    head :no_content
  end
end
