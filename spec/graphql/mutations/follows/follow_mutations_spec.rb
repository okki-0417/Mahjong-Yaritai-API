# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Follow Mutations", type: :request do
  include GraphqlHelper

  describe "createFollow" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { { userId: target_user.id.to_s } }
    let(:target_user) { create(:user) }
    let(:mutation) do
      <<~GQL
        mutation($userId: ID!) {
          createFollow(input: { userId: $userId }) {
            follow {
              id
              followerId
              followeeId
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーを返ること" do
        json = subject

        expect(json[:data][:createFollow]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "saveが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          follow = instance_double(Follow, save: false, errors:)
          allow(current_user.active_follows).to receive(:new).and_return(follow)
        end

        it "バリデーションエラーを返すこと" do
          json = subject

          expect(json[:data][:createFollow]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "saveが成功する場合" do
        it "フォローを作成すること" do
          json = subject

          expect(json[:data][:createFollow][:follow]).to be_present
        end
      end
    end
  end

  describe "deleteFollow" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:target_user) { create(:user) }
    let(:follow) { create(:follow, follower: current_user, followee: target_user) }
    let(:variables) { { userId: target_user.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($userId: ID!) {
          deleteFollow(input: { userId: $userId }) {
            success
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteFollow]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "削除が成功する場合" do
        it "フォローが削除できること" do
          follow  # フォローを作成
          json = subject

          expect(json[:data][:deleteFollow][:success]).to eq(true)
        end
      end
    end
  end
end
