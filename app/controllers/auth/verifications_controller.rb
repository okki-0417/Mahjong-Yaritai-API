# frozen_string_literal: true

class Auth::VerificationsController < Auth::BaseController
  def create
    auth_request = Auth::Request.find_by(token: auth_verification_params[:token])

    if auth_request && !auth_request.expired?
      user = User.find_by(email: auth_request.email)

      if user
        login user
        remember user

        auth_request.destroy!

        render json: user, serializer: UserSerializer, root: :auth_verification, status: :created
      else
        session[:auth_request_id] = auth_request.id
        render json: {}, status: :ok
      end
    else
      render json: error_json([ "認証に失敗しました" ]), status: :unprocessable_entity
    end
  end

  private

    def auth_verification_params
      params.require(:auth_verification).permit(:token)
    end
end
