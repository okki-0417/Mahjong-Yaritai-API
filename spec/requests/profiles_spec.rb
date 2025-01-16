# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Profile", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#show" do
    subject { get profile_url }

    context "未ログインの場合" do
      it_behaves_like :status, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it_behaves_like :status, 200
    end
  end

  describe "#update" do
    subject { patch profile_url, params: {
      user: {
        name: "new_name",
        email: "new_email",
        # profile_image: fixture_file_upload("files/sample.jpg", "image/jpeg")
      } }
    }

    context "未ログインの場合" do
      it_behaves_like :status, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it_behaves_like :status, 201
    end
  end
end
