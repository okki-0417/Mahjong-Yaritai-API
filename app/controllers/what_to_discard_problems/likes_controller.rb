# frozen_string_literal: true

class WhatToDiscardProblems::LikesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    likes = WhatToDiscardProblem.find(params[:what_to_discard_problem_id]).likes
    is_current_user_liked = likes.exists?(user_id: current_user&.id)

    render json: {
      what_to_discard_problem_likes: {
        count: likes.size,
        is_current_user_liked:,
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
        what_to_discard_problem_like: {
          myLike: like,
        }
      }, status: :created
    else
      render json: validation_error_json(like), status: :unprocessable_entity
    end
  end

  def destroy
    like = current_user.created_what_to_discard_problem_likes.find(params[:id])

    like.destroy

    render json: {
      what_to_discard_problem_like: {
        myLike: nil
      }
    }, status: :no_content
  end
end
