# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:current_user) { create(:user, password: "password", password_confirmation: "password") }

  describe "#create" do
    subject do
      post session_url, params: {
        session: {
          email: current_user.email,
          password:,
        },
      }
    end
    let(:password) { "password" }

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "403を返すこと" do
        subject
        expect(response).to have_http_status(403)
      end
    end

    context "未ログインの場合" do
      context "正しい値の場合" do
        it "ログインして201を返すこと" do
          subject
          expect(response).to have_http_status(201)
        end
      end

      context "不正な値の場合" do
        it "422を返すこと" do
          post session_url, params: {
            session: {
              email: current_user.email,
              password: "wrong_password",
            },
          }
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe "#show" do
    subject { get session_url }

    it_behaves_like :response, 200
  end

  describe "#destroy" do
    subject { delete session_url }

    context "既にログインしている場合" do
      it "204を返すこと" do
        subject
      end
    end
  end
end
