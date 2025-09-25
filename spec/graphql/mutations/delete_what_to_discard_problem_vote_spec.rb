# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Mutations::DeleteWhatToDiscardProblemVote", type: :request do
  let(:mutation) do
    <<~GQL
      mutation($whatToDiscardProblemId: ID!) {
        deleteWhatToDiscardProblemVote(
          input: {
            whatToDiscardProblemId: $whatToDiscardProblemId
          }
        ) {
          success
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

  describe "deleteWhatToDiscardProblemVote" do
    let(:user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let!(:vote) do
      create(:what_to_discard_problem_vote,
        what_to_discard_problem: problem,
        user: user)
    end

    context "when user is logged in" do
      it "deletes the vote successfully" do
        execute_mutation(
          variables: { whatToDiscardProblemId: problem.id.to_s },
          current_user: user
        )

        json = JSON.parse(response.body, symbolize_names: true)
        result = json[:data][:deleteWhatToDiscardProblemVote]

        expect(response).to have_http_status(:ok)
        expect(result[:success]).to eq(true)
        expect(result[:errors]).to be_nil
        expect(WhatToDiscardProblem::Vote.exists?(vote.id)).to eq(false)
      end

      it "returns error when vote does not exist" do
        vote.destroy!

        execute_mutation(
          variables: { whatToDiscardProblemId: problem.id.to_s },
          current_user: user
        )

        json = JSON.parse(response.body, symbolize_names: true)
        result = json[:data][:deleteWhatToDiscardProblemVote]

        expect(result[:success]).to eq(false)
        expect(result[:errors]).to include("Vote not found")
      end
    end

    context "when user is not logged in" do
      it "returns an error" do
        execute_mutation(
          variables: { whatToDiscardProblemId: problem.id.to_s }
        )

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:errors]).to be_present
        expect(json[:errors][0][:message]).to include("User must be logged in")
      end
    end
  end
end