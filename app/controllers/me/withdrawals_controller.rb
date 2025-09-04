# frozen_string_literal: true

class Me::WithdrawalsController < Me::BaseController
  def create
    user_email = current_user.email
    user_name = current_user.name

    if current_user.delete_account
      reset_session

      WithdrawalMailer.withdrawal_completed(user_email, user_name).deliver_later

      render body: nil, status: :no_content
    else
      render json: error_json([ "退会処理に失敗しました" ]), status: :unprocessable_entity
    end
  end
end
