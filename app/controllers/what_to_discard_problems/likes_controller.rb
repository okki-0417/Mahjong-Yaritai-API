# frozen_string_literal: true

class WhatToDiscardProblems::LikesController < WhatToDiscardProblems::BaseController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    problem = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
    likes = problem.likes

    current_user_like_id = likes.find_by(user_id: current_user&.id)&.id

    render json: {
      what_to_discard_problem_likes: {
        count: likes.size,
        current_user_like_id:,
      }
    }, status: 200
  end

  def create
    like = WhatToDiscardProblem::Like.new(
      user_id: current_user.id,
      what_to_discard_problem_id: params[:what_to_discard_problem_id]
    )

    if like.save
      render json: {
        what_to_discard_problem_likes: {
          count: like.what_to_discard_problem.likes_count,
          current_user_like_id: like.id,
        }
      }, status: :created
    else
      puts like.errors.full_messages
      render json: validation_error_json(like), status: :unprocessable_entity
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
