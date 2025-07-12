# frozen_string_literal: true

class Me::BaseController < ApplicationController
  before_action :restrict_to_logged_in_user
end
