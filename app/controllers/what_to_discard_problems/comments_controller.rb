# frozen_string_literal: true

class WhatToDiscardProblems::CommentsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: [ :create ]

  def create
    comment = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
                                  .comments
                                  .new(**comment_params, user_id: current_user.id,)

    if comment.save
      render json: { what_to_discard_problem_comment: comment }, status: :created
    else
      render json: { errors: comment.errors.full_messages.map { |message| { message: } } }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:what_to_discard_problem_comment).permit(:content, :reply_to_comment_id)
  end
end
