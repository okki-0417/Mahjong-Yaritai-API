# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Follow Mutations", type: :request do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  def execute_mutation(mutation, variables, current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql", params: { query: mutation, variables: variables }, as: :json
  end

  describe "createFollow" do
    let(:mutation) do
      <<~GQL
        mutation($userId: ID!) {
          createFollow(input: { userId: $userId }) {
            success
            errors
          }
        }
      GQL
    end

    it "creates a follow" do
      execute_mutation(mutation, { userId: target_user.id.to_s }, current_user: user)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:createFollow][:success]).to eq(true)
    end
  end

  describe "deleteFollow" do
    let(:mutation) do
      <<~GQL
        mutation($userId: ID!) {
          deleteFollow(input: { userId: $userId }) {
            success
            errors
          }
        }
      GQL
    end

    it "deletes a follow" do
      create(:follow, follower: user, followee: target_user)
      execute_mutation(mutation, { userId: target_user.id.to_s }, current_user: user)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:deleteFollow][:success]).to eq(true)
    end
  end
end
