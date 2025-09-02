# frozen_string_literal: true

class Me::ProfilesController < Me::BaseController
  def show
    render json: current_user,
      root: :profile,
      serializer: UserSerializer
  end

  def update
    # formDataで受け取るため、StrongParameter(JSON)を使えない
    update_params = { name: params[:name] }
    update_params[:profile_text] = params[:profile_text] if params[:profile_text].present?
    update_params[:avatar] = params[:avatar] if params[:avatar].present? && params[:avatar] != "undefined"

    if current_user.update(update_params)
      render json: current_user,
        serializer: UserSerializer,
        root: :user,
        status: :ok
    else
      render json: validation_error_json(current_user), status: :unprocessable_entity
    end
  end
end
