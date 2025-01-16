# frozen_string_literal: true

class CsrfTokensController < ApplicationController
  before_action :restrict_to_logged_in_user, only: [ :show ]

  def show
    if session[:_csrf_token].blank?
      render json: { csrf_token: form_authenticity_token }, status: :ok
    else
      render json: { csrf_token: session[:_csrf_token] }, status: :ok
    end
  end
end
