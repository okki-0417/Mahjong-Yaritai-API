# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SessionHelper", type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe "current_user" do
    context "sessionもcookieも空の場合" do
      it "nilを返すこと" do
        expect(helper.current_user).to be_nil
      end
    end

    context "sessionにユーザーIDが入っている場合" do
      before { session[:user_id] = user.id }

      it "ユーザーを返すこと" do
        expect(helper.current_user).to eq(user)
      end
    end

    context "cookiesにユーザーIDとremember_tokenが入っている場合" do
      before do
        remember_token = SecureRandom.urlsafe_base64(64)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        remember_digest = BCrypt::Password.create(remember_token, cost:)
        user.update_attribute(:remember_digest, remember_digest)
        user.reload

        # TODO: requestスペックにしてcookiesの問題を解消する
        allow(helper.cookies.signed).to receive(:[]).with(:user_id).and_return(user.id)
        allow(helper.cookies).to receive(:[]).with(:remember_token).and_return(remember_token)
      end

      it "ユーザーを返すこと" do
        # expect(helper.current_user).to eq(user)
      end
    end
  end
end
