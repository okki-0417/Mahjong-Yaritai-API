# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::CurrentSession", type: :request do
  let(:query) do
    <<~GQL
      query {
        currentSession {
          isLoggedIn
          userId
          user {
            id
            name
            avatarUrl
          }
        }
      }
    GQL
  end

  def execute_query(user: nil)
    if user
      # ログインヘルパーを使用してセッションを設定
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql",
      params: { query: query },
      as: :json
  end

  describe "currentSession" do
    context "when user is not logged in" do
      it "returns session with isLoggedIn: false" do
        execute_query

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:currentSession]).to include(
          isLoggedIn: false,
          userId: nil,
          user: nil
        )
      end
    end

    context "when user is logged in" do
      let(:user) { create(:user, name: "Test User") }

      it "returns session with user information" do
        execute_query(user: user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:currentSession]).to include(
          isLoggedIn: true,
          userId: user.id
        )
        expect(json[:data][:currentSession][:user]).to include(
          id: user.id.to_s,
          name: "Test User"
        )
      end
    end

    context "when user has avatar" do
      let(:user) { create(:user) }

      before do
        user.avatar.attach(
          io: File.open(Rails.root.join("spec/fixtures/images/test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end

      it "returns avatar_url" do
        execute_query(user: user)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:currentSession][:user][:avatarUrl]).to be_present
      end
    end
  end
end
