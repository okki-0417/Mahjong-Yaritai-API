# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def registration_email(email:, token:)
    @token = token

    mail(
      to: email,
      subject: "【麻雀ヤリタイ】ユーザー仮登録完了のお知らせ",
    )
  end
end
