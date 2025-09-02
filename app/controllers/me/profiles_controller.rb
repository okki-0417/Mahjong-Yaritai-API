# frozen_string_literal: true

class Me::ProfilesController < Me::BaseController
  def show
    render json: current_user,
      root: :profile,
      serializer: UserSerializer
  end
end
