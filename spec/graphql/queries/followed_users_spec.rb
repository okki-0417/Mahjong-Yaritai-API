# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::FollowedUsers", type: :request do
  let(:query) do
    <<~GQL
      query {
        followedUsers {
          id
          name
          profileText
          avatarUrl
          isFollowing
          createdAt
        }
      }
    GQL
  end

  def execute_query(current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql",
      params: { query: query },
      as: :json
  end

  describe "followedUsers" do
    let(:current_user) { create(:user) }
    let!(:followed_user1) { create(:user, name: "User 1") }
    let!(:followed_user2) { create(:user, name: "User 2") }
    let!(:other_user) { create(:user, name: "Other User") }

    context "when user has no following" do
      it "returns empty array" do
        execute_query(current_user: current_user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:followedUsers]).to eq([])
      end
    end

    context "when user is following some users" do
      before do
        create(:follow, follower: current_user, followee: followed_user1, created_at: 2.days.ago)
        create(:follow, follower: current_user, followee: followed_user2, created_at: 1.day.ago)
      end

      it "returns followed users in descending order of follow date" do
        execute_query(current_user: current_user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:followedUsers].size).to eq(2)

        # 最新のフォローが最初に来ることを確認
        expect(json[:data][:followedUsers][0][:name]).to eq("User 2")
        expect(json[:data][:followedUsers][1][:name]).to eq("User 1")

        # 各ユーザーの詳細が正しく返されることを確認
        json[:data][:followedUsers].each do |user|
          expect(user).to include(
            :id,
            :name,
            :profileText,
            :avatarUrl,
            :isFollowing,
            :createdAt
          )
          expect(user[:isFollowing]).to eq(true)
        end
      end
    end

    context "when user is not logged in" do
      it "returns empty array" do
        execute_query

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:followedUsers]).to eq([])
      end
    end

    context "when followed user has avatar" do
      before do
        followed_user1.avatar.attach(
          io: File.open(Rails.root.join("spec/fixtures/images/test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
        create(:follow, follower: current_user, followee: followed_user1)
      end

      it "returns avatar_url" do
        execute_query(current_user: current_user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:followedUsers][0][:avatarUrl]).to be_present
      end
    end
  end
end
