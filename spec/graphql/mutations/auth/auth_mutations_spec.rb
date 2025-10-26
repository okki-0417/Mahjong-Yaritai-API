# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Auth Mutations", type: :request do
  include GraphqlHelper

  describe "requestAuth" do
    subject do
      execute_mutation(mutation, variables, context: { current_user:, session: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { nil }
    let(:session) { {} }
    let(:email) { "test@example.com" }
    let(:variables) { { email: } }
    let(:mutation) do
      <<~GQL
        mutation($email: String!) {
          requestAuth(input: { email: $email }) {
            success
          }
        }
      GQL
    end

    context "既にログインしている場合" do
      let(:current_user) { create(:user) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:requestAuth]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "saveが失敗する場合" do
      before do
        errors = double(full_messages: [ "バリデーションエラー" ])
        auth_request = instance_double(AuthRequest, save: false, errors:)
        allow(AuthRequest).to receive(:new).and_return(auth_request)
      end

      it "バリデーションエラーが返ること" do
        json = subject

        expect(json[:data][:requestAuth]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "saveが成功する場合" do
      it "認証リクエストが作成できること" do
        expect {
          subject
        }.to change(ActionMailer::Base.deliveries, :count).by(1)

        json = subject

        expect(json[:data][:requestAuth][:success]).to eq(true)
        expect(session[:pending_auth_email]).to eq(email)
      end
    end
  end

  describe "verifyAuth" do
    subject do
      execute_mutation(mutation, variables, context: { current_user:, session: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { nil }
    let(:session) { { pending_auth_email: email } }
    let(:email) { "test@example.com" }
    let(:token) { "123456" }
    let(:auth_request) { create(:auth_request, email:, token:) }
    let(:variables) { { token: } }
    let(:mutation) do
      <<~GQL
        mutation($token: String!) {
          verifyAuth(input: { token: $token }) {
            user {
              id
              email
              name
            }
          }
        }
      GQL
    end

    context "既にログインしている場合" do
      let(:current_user) { create(:user) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:verifyAuth]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "pending_auth_emailがセッションにない場合" do
      let(:session) { {} }

      before { auth_request }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:verifyAuth]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "トークンが期限切れの場合" do
      before do
        auth_request
        allow_any_instance_of(AuthRequest).to receive(:expired?).and_return(true)
      end

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:verifyAuth]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "検証が成功する場合" do
      context "新規ユーザーの場合" do
        before { auth_request }

        it "userがnilで返ること" do
          expect {
            json = subject
            expect(json[:data][:verifyAuth][:user]).to be_nil
            expect(session[:pending_auth_email]).to be_nil
          }.not_to change(User, :count)
        end
      end

      context "既存ユーザーの場合" do
        let(:user) { create(:user, email:) }

        before do
          user
          auth_request
        end

        it "ログインできること" do
          expect {
            json = subject
            expect(json[:data][:verifyAuth][:user][:id]).to eq(user.id.to_s)
            expect(session[:pending_auth_email]).to be_nil
          }.not_to change(User, :count)
        end
      end
    end
  end
end
