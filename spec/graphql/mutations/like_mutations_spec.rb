# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Like Mutations", type: :request do
  let(:user) { create(:user) }
  let(:problem) { create(:what_to_discard_problem) }

  def execute_mutation(mutation, variables, current_user: nil)
    if current_user
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    else
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(nil)
    end

    post "/graphql", params: { query: mutation, variables: variables }, as: :json
  end

  describe "createWhatToDiscardProblemLike" do
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!) {
          createWhatToDiscardProblemLike(input: { whatToDiscardProblemId: $whatToDiscardProblemId }) {
            success
            errors
          }
        }
      GQL
    end

    it "creates a like" do
      execute_mutation(mutation, { whatToDiscardProblemId: problem.id.to_s }, current_user: user)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:createWhatToDiscardProblemLike][:success]).to eq(true)
    end
  end

  describe "deleteWhatToDiscardProblemLike" do
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!) {
          deleteWhatToDiscardProblemLike(input: { whatToDiscardProblemId: $whatToDiscardProblemId }) {
            success
            errors
          }
        }
      GQL
    end

    it "deletes a like" do
      create(:like, user: user, likable: problem)
      execute_mutation(mutation, { whatToDiscardProblemId: problem.id.to_s }, current_user: user)
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:deleteWhatToDiscardProblemLike][:success]).to eq(true)
    end
  end
end
