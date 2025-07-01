require "swagger_helper"

RSpec.describe "what_to_discard_problems/votes/results", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/votes/result" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"

    get("get result") do
      tags "WhatToDiscardProblem::Vote::Result"
      operationId "getWhatToDiscardProblemVoteResult"
      produces "application/json"

      response(200, "ok") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        before { create(:what_to_discard_problem_vote, what_to_discard_problem:) }

        schema type: :object,
          required: %w[what_to_discard_problem_vote_result],
          properties: {
            what_to_discard_problem_vote_result: {
              type: :array,
              items: { "$ref" => "#/components/schemas/WhatToDiscardProblemVoteResult" },
            },
          }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end
end
