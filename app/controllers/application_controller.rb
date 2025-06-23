class ApplicationController < ActionController::API
  include Authenticatable
  include ErrorJsonRenderable
  include Paginationable

  include Rails.application.routes.url_helpers
  include ActionController::RequestForgeryProtection

  def reject_logged_in_user
    render json: { errors: [ { message:  "Already logged in." } ] }, status: :forbidden if logged_in?
  end

  def restrict_to_logged_in_user
    render json: { errors: [ message: "Not logged in." ] }, status: :unauthorized unless logged_in?
  end
end
