# frozen_string_literal: true

require "rails_helper"

RSpec.describe "CsrfTokensController", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "create" do
    subject { get csrf_token_url }

    context "未ログインの場合" do
      it_behaves_like :status, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"
      it_behaves_like :status, 200
    end
  end
end
