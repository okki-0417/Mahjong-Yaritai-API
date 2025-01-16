# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :restrict_to_logged_in_user

  def show
    head :ok
  end

  def update
    head :created
  end
end
