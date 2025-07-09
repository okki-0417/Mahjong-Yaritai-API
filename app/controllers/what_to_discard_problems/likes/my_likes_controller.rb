# frozen_string_literal: true

class WhatToDiscardProblems::Likes::MyLikesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def show
    my_like = Like.find_by(
      likable_type: WhatToDiscardProblem.name,
      likable_id: params[:what_to_discard_problem_id],
      user_id: current_user&.id,
    )

    return render json: { my_like: nil }, status: :no_content unless my_like

    render json: my_like,
      serializer: LikeSerializer,
      root: :my_like,
      status: :ok
  end

  def create
    like = current_user.created_likes.new(
      likable_type: WhatToDiscardProblem.name,
      likable_id: params[:what_to_discard_problem_id]
    )

    if like.save
      render json: like,
        serializer: LikeSerializer,
        root: :what_to_discard_problem_my_like,
        status: :created
    else
      render json: validation_error_json(like), status: :unprocessable_entity
    end
  end

  def destroy
    like = current_user.created_likes.find_by!(
      likable_type: WhatToDiscardProblem.name,
      likable_id: params[:what_to_discard_problem_id]
    )

    like.destroy!

    head :no_content
  end
end
