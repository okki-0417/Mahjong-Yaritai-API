# frozen_string_literal: true

class WhatToDiscardProblems::Comments::RepliesController < ApplicationController
  before_action :restrict_to_logged_in_user, only: %i[create destroy]

  def index
    render json: {}, status: :ok
  end

  def create
    render json: {}, status: :created
  end

  def destroy
    head :no_content
  end
end
