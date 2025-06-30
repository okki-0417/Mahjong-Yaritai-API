# frozen_string_literal: true

class WhatToDiscardProblems::Comments::RepliesController < ApplicationController
  def index
    replies = Comment.find(params[:comment_id]).replies

    render json: replies,
      each_serializer: CommentSerializer,
      root: :what_to_discard_problem_comment_replies,
      status: :ok
  end
end
