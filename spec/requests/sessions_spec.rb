# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#create" do
    subject { post session_url, params: {
      email: current_user.email,
      password: "password"
    }}

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
            email: current_user.email,
            password: "wrong_password"
          }
          expect(response).to have_http_status(422)
        end
      end
    end
  end

  describe "#destroy" do
    subject { delete session_url }

    context "既にログインしている場合" do
      it "204を返すこと" do
        subject
      end
    end
  end

  describe "#state" do
    subject { get state_session_url }

    context "未ログインの場合" do
      it "falseを返すこと" do
        subject
        expect(response).to have_http_status(200)

        parsed_body = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_body).to eq(auth: false)
      end
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      it "trueを返すこと" do
        subject
        expect(response).to have_http_status(200)

        parsed_body = JSON.parse(response.body, symbolize_names: true)
        expect(parsed_body).to eq(auth: true)
      end
    end
  end
end
