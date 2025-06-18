# frozen_string_literal: true

class WhatToDiscardProblems::Comments::RepliesController < ApplicationController
  def index
    replies = Comment.find(params[:comment_id]).replies

    render json: replies, each_serializer: CommentSerializer, status: :ok
  end
end
