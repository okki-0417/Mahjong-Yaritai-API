# frozen_string_literal: true

class Auth::BaseController < ApplicationController
  before_action :reject_logged_in_user
end
