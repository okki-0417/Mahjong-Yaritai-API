# frozen_string_literal: true

class WhatToDiscardProblems::Comments::RepliesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    replies = Comment.find(params[:comment_id]).replies

    render json: {
      what_to_discard_problem_comment_replies: replies
    }, status: :ok
  end

  def create
    reply = current_user.created_comments.new(
      commentable_type: WhatToDiscardProblem.name,
      commentable_id: params[:what_to_discard_problem_id],
      **reply_params,
    )

    if reply.save
      render json: {
        what_to_discard_problem_comment_reply: reply
        }, status: :created
    else
      render json: validation_error_json(reply), status: :unprocessable_entity
    end
  end

  def destroy
    head :no_content
  end

  private

  def reply_params
    params.require(:what_to_discard_problem_comment_reply).permit(:content, :parent_comment_id)
  end
end
