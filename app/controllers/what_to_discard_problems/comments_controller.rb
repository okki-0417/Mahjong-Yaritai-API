# frozen_string_literal: true

class WhatToDiscardProblems::CommentsController < WhatToDiscardProblems::BaseController
  before_action :restrict_to_logged_in_user, only: [ :create ]

  def index
    parent_comments = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
                                          .comments
                                          .parents
                                          .preload(:user, :replies)
                                          .order(created_at: :asc)
                                          .limit(5)

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
    comment = WhatToDiscardProblem.find(params[:what_to_discard_problem_id])
                                  .comments
                                  .new(**comment_params, user_id: current_user.id,)

    if comment.save
      render json: { what_to_discard_problem_comment: comment }, status: :created
    else
      render json: validation_error_json(comment), status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:what_to_discard_problem_comment).permit(:content, :parent_comment_id)
  end
end
