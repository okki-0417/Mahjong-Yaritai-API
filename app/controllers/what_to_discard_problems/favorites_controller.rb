# frozen_string_literal: true

class WhatToDiscardProblems::LikesController < WhatToDiscardProblems::BaseController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def create
    like = WhatToDiscardProblem::Like.new(
      user_id: current_user.id,
      what_to_discard_problem_id: params[:what_to_discard_problem_id]
    )

    if like.save
      render json: {
        what_to_discard_problem_like: like.as_json(
          only: [:id]
        )
      }, status: :created
    else
      render json: { errors: like.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    like = WhatToDiscardProblem::Like.find_by!(
      user_id: current_user.id,
      what_to_discard_problem_id: params[:what_to_discard_problem_id]
    )

    like.destroy

    head :no_content
  end
end
