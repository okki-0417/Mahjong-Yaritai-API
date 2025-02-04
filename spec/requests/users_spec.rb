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
    let(:name) { "test_name" }
    let(:password) { "test_password" }
    let(:password_confirmation) { password }

    subject { post users_url,
      params: {
        user: {
          name:,
          password:,
          password_confirmation:,
        }
      }
    }

    context "Authorizationが存在しない場合" do
      before { allow_any_instance_of(UsersController).to receive(:redis_get).and_return(nil) }

      it_behaves_like :response, 422
    end

    context "Authorizationが存在する場合" do
      let(:authorization) { FactoryBot.create(:authorization) }

      before { allow(Authorization).to receive(:find_by).and_return(authorization) }

      context "モデルのバリデーションに通らない場合" do
        before { allow_any_instance_of(User).to receive(:save).and_return(false) }

        it_behaves_like :response, 422
      end

      context "モデルのバリデーションに通る場合" do
        it_behaves_like :response, 201
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
