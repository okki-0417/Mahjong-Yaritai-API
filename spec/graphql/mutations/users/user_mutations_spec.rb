# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Mutations", type: :request do
  include GraphqlHelper

  describe "createUser" do
    subject do
      execute_mutation(mutation, variables, context: { session: session_params })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:name) { "Test User" }
    let(:auth_request) { create(:auth_request, email:) }
    let(:email) { "xxx@xxx.com" }
    let(:session_params) { { auth_request_id: auth_request.id } }
    let(:variables) { { name:, profile_text: } }
    let(:profile_text) { "This is a test user." }
    let(:mutation) do
      <<~GQL
        mutation($name: String!, $profileText: String, $avatar: Upload) {
          createUser(input: {
            name: $name
            profileText: $profileText
            avatar: $avatar
          }) {
            user {
              id
              email
              name
              profileText
            }
          }
        }
      GQL
    end

    context "認証がない場合" do
      let(:session_params) { {} }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "認証が無効な場合" do
      before { allow_any_instance_of(AuthRequest).to receive(:expired?).and_return(true) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "saveが失敗する場合" do
      before do
        errors = double(full_messages: [ "バリデーションエラー" ])
        user = instance_double(User, save: false, errors:)
        allow(User).to receive(:new).and_return(user)
        allow(user).to receive(:avatar).and_return(double(attach: nil))
      end

      it "バリデーションエラーが返ること" do
        json = subject

        expect(json[:data][:createUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "saveが成功する場合" do
      it "ユーザーを作成できること" do
        json = subject

        expect(json[:data][:createUser]).to be_present
      end
    end
  end

  describe "logout" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { {} }
    let(:mutation) do
      <<~GQL
        mutation {
          logout(input: {}) {
            success
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:logout]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      it "ログアウトできること" do
        json = subject

        expect(json[:data][:logout][:success]).to eq(true)
      end
    end
  end

  describe "updateUser" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { { name: "Updated Name", profileText: "Updated profile" } }
    let(:mutation) do
      <<~GQL
        mutation($name: String, $profileText: String, $avatar: Upload) {
          updateUser(input: { name: $name, profileText: $profileText, avatar: $avatar }) {
            user {
              id
              name
              profileText
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:updateUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "updateが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          allow(current_user).to receive(:update).and_return(false)
          allow(current_user).to receive(:errors).and_return(errors)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:updateUser]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "updateが成功する場合" do
        it "ユーザーを更新できること" do
          json = subject

          expect(json[:data][:updateUser][:user][:name]).to eq("Updated Name")
          expect(json[:data][:updateUser][:user][:profileText]).to eq("Updated profile")
        end
      end
    end
  end

  describe "withdrawUser" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { {} }
    let(:mutation) do
      <<~GQL
        mutation {
          withdrawUser(input: {}) {
            success
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:withdrawUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "削除が失敗する場合" do
      before do
        errors = double(full_messages: [ "削除エラー" ])
        allow(current_user).to receive(:destroy).and_return(false)
        allow(current_user).to receive(:errors).and_return(errors)
      end

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:withdrawUser]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "削除が成功する場合" do
      it "ユーザーが退会できること" do
        current_user  # ユーザーを先に作成

        expect {
          json = subject
          expect(json[:data][:withdrawUser][:success]).to eq(true)
        }.to change(User, :count).by(-1)
      end
    end
  end
end
