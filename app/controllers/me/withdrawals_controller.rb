# frozen_string_literal: true

class Me::WithdrawalsController < Me::BaseController
  def create
    user_email = current_user.email
    user_name = current_user.name

    ActiveRecord::Base.transaction do
      # ユーザーに関連するデータを削除
      current_user.created_what_to_discard_problems.destroy_all
      current_user.created_comments.destroy_all
      current_user.created_likes.destroy_all
      current_user.created_what_to_discard_problem_votes.destroy_all

      # ユーザー自身を削除
      current_user.destroy!

      # セッション破棄
      reset_session
    end

    # 退会完了メールを送信（非同期）
    WithdrawalMailer.withdrawal_completed(user_email, user_name).deliver_later

    render body: nil, status: :no_content
  rescue ActiveRecord::RecordNotDestroyed
    render json: error_json([ "退会処理に失敗しました" ]), status: :unprocessable_entity
  end
end
