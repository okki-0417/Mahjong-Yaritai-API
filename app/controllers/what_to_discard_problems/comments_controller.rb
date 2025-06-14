# frozen_string_literal: true

class WhatToDiscardProblems::CommentsController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    parent_comments = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
                                          .comments
                                          .parents
                                          .preload(:user)
                                          .order(created_at: :asc)

    render json: {
      what_to_discard_problem_comments: parent_comments.as_json(
        only: [:id, :content, :created_at],
        include: {
          user: { only: [:id, :name] },
          replies: {
            only: [:id, :content, :created_at],
            include: { user: { only: [:id, :name] } }
          }
        }
      )
    }, status: :ok
  end

  def create
    comment = current_user.created_comments
                          .new(
                            commentable_type: WhatToDiscardProblem.name,
                            commentable_id: params[:what_to_discard_problem_id],
                            **comment_params,
                          )

    if comment.save
      parent_comments = comment.commentable
                               .comments
                               .parents
                               .preload(:user, :replies)
                               .order(created_at: :asc)

      render json: {
        what_to_discard_problem_comments: {
          comments: parent_comments.as_json(
            only: [:id, :content, :created_at],
            include: {
              user: { only: [:id, :name] },
              replies: {
                only: [:id, :content, :created_at],
                include: { user: { only: [:id, :name] } }
              }
            }
          ),
          total_count: comment.commentable.comments_count
        }
      }, status: :created
    else
      render json: validation_error_json(comment), status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.created_comments
                          .find(params[:id])

    comment.destroy!

    head :no_content
  end

  private

  def comment_params
    params.require(:what_to_discard_problem_comment).permit(:content, :parent_comment_id)
  end
end
