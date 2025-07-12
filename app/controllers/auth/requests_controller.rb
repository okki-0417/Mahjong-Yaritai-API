# frozen_string_literal: true

class Auth::RequestsController < Auth::BaseController
  def create
    auth_request = Auth::Request.new(auth_request_params)

    if auth_request.save
      AuthorizationMailer.send_authorization_link(auth_request).deliver_now

      head :created
    else
      render json: validation_error_json(auth_request), status: :unprocessable_entity
    end
  end

  private

    def auth_request_params
      params.require(:auth_request).permit(:email)
    end
end
