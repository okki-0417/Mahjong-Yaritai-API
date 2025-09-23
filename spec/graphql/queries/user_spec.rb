# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::User", type: :request do
  let(:query) do
    <<~GQL
      query($id: ID!) {
        user(id: $id) {
          id
          name
          profileText
          avatarUrl
          isFollowing
        }
      }
    GQL
  end

  def execute_query(variables:, current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql",
      params: { query: query, variables: variables },
      as: :json
  end

  describe "user" do
    let(:target_user) { create(:user, name: "Test User") }

    context "when user exists" do
      it "returns user information" do
        execute_query(variables: { id: target_user.id })

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:user]).to include(
          id: target_user.id.to_s,
          name: "Test User",
          profileText: target_user.profile_text
        )
      end
    end

    context "when user has avatar" do
      before do
        target_user.avatar.attach(
          io: File.open(Rails.root.join("spec/fixtures/images/test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end

      it "returns avatar_url" do
        execute_query(variables: { id: target_user.id })

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:user][:avatarUrl]).to be_present
      end
    end

    context "when current user is not following" do
      let(:current_user) { create(:user) }

      it "returns isFollowing: false" do
        execute_query(variables: { id: target_user.id }, current_user: current_user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:user][:isFollowing]).to eq(false)
      end
    end

    context "when current user is following" do
      let(:current_user) { create(:user) }

      before do
        create(:follow, follower: current_user, followee: target_user)
      end

      it "returns isFollowing: true" do
        execute_query(variables: { id: target_user.id }, current_user: current_user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:user][:isFollowing]).to eq(true)
      end
    end

    context "when user not logged in" do
      it "returns isFollowing: false" do
        execute_query(variables: { id: target_user.id })

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:user][:isFollowing]).to eq(false)
      end
    end
  end
end
