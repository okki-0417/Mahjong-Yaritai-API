module Mutations
  class WithdrawUser < BaseMutation
    field :success, Boolean, null: false
    field :errors, [String], null: false

    def resolve
      return { success: false, errors: ["ログインが必要です"] } unless context[:current_user]

      user = context[:current_user]

      begin
        # ユーザーに関連するデータを削除
        user.destroy

        # メール通知（必要に応じて）
        # UserMailer.withdrawal_notification(user).deliver_now

        { success: true, errors: [] }
      rescue => e
        { success: false, errors: [e.message] }
      end
    end
  end
end