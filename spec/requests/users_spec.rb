# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  include SessionHelper

  let(:current_user) { FactoryBot.create(:user) }

  describe "index" do
    subject { get users_url }

    context "未ログインの場合" do
      it "401を返すこと" do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "200を返すこと" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "show" do
    subject { get user_url(current_user) }

    context "未ログインの場合" do
      it "401を返すこと" do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "200を返すこと" do
        subject
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "create" do
    subject { post users_url, params: {
      user: {
        name: "test_user",
        email: "test@test.com",
        password: "password",
        password_confirmation: "password"
      }
    }}

    context "未ログインの場合" do
      it "ユーザーを作成・ログイン処理して201を返すこと" do
        expect { subject }.to change { User.count }.by(1)
        expect(response).to have_http_status(201)
        expect(logged_in?).to eq true
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "403を返すこと" do
        subject
        expect(response).to have_http_status(403)
      end
    end
  end

  describe "update" do
    let(:updated_name) { "updated_name" }
    subject { patch user_url(current_user), params: {
      user: {
        name: updated_name
        }
    }}

    context "未ログインの場合" do
      it "401を返すこと" do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "更新して200を返すこと" do
        subject
        expect(current_user.reload.name).to eq updated_name
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "destroy" do
    subject { delete user_url(current_user) }

    context "未ログインの場合" do
      it "401を返すこと" do
        subject
        expect(response).to have_http_status(401)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "204を返すこと" do
        expect { subject }.to change { User.count }.by(-1)
        expect(response).to have_http_status(204)
      end
    end
  end
end
