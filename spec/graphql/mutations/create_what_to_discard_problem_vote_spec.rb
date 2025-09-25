# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mutations::CreateWhatToDiscardProblemVote", type: :request do
  let(:mutation) do
    <<~GQL
      mutation($whatToDiscardProblemId: ID!, $tileId: ID!) {
        createWhatToDiscardProblemVote(
          input: {
            whatToDiscardProblemId: $whatToDiscardProblemId
            tileId: $tileId
          }
        ) {
          vote {
            id
            tileId
            whatToDiscardProblemId
            userId
            tile {
              id
              suit
              ordinalNumberInSuit
            }
          }
          errors
        }
      }
    GQL
  end

  def execute_mutation(variables:, current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql",
      params: { query: mutation, variables: variables },
      as: :json
  end

  describe "createWhatToDiscardProblemVote" do
    let(:user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:tile) { create(:tile) }

    context "when user is logged in" do
      it "creates a vote successfully" do
        execute_mutation(
          variables: {
            whatToDiscardProblemId: problem.id.to_s,
            tileId: tile.id.to_s,
          },
          current_user: user
        )

        json = JSON.parse(response.body, symbolize_names: true)
        vote_data = json[:data][:createWhatToDiscardProblemVote]

        expect(response).to have_http_status(:ok)
        expect(vote_data[:errors]).to eq([])
        expect(vote_data[:vote][:tileId]).to eq(tile.id.to_s)
        expect(vote_data[:vote][:whatToDiscardProblemId]).to eq(problem.id.to_s)
        expect(vote_data[:vote][:userId]).to eq(user.id.to_s)
      end

      it "includes tile information" do
        execute_mutation(
          variables: {
            whatToDiscardProblemId: problem.id.to_s,
            tileId: tile.id.to_s,
          },
          current_user: user
        )

        json = JSON.parse(response.body, symbolize_names: true)
        tile_data = json[:data][:createWhatToDiscardProblemVote][:vote][:tile]

        expect(tile_data[:id]).to eq(tile.id.to_s)
        expect(tile_data[:suit]).to eq(tile.suit)
        expect(tile_data[:ordinalNumberInSuit]).to eq(tile.ordinal_number_in_suit)
      end

      it "returns errors when validation fails" do
        create(:what_to_discard_problem_vote,
          what_to_discard_problem: problem,
          user: user,
          tile: tile)

        execute_mutation(
          variables: {
            whatToDiscardProblemId: problem.id.to_s,
            tileId: tile.id.to_s,
          },
          current_user: user
        )

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:errors]).to be_present
        expect(json[:errors][0][:message]).to be_present
      end
    end

    context "when user is not logged in" do
      it "returns an error" do
        execute_mutation(
          variables: {
            whatToDiscardProblemId: problem.id.to_s,
            tileId: tile.id.to_s,
          }
        )

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:errors]).to be_present
        expect(json[:errors][0][:message]).to include("User must be logged in")
      end
    end
  end
end
