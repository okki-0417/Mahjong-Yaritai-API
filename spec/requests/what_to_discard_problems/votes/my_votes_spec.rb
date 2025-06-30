# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "what_to_discard_problems/votes/my_votes", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/votes/my_vote" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"

    get("show my_vote") do
      tags "WhatToDiscardProblem::Comment::MyVote"
      operationId "getMyVote"
      produces "application/json"

      response(200, "successful") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        before { create(:what_to_discard_problem_vote, what_to_discard_problem:, user: current_user) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          nullable: true,
          properties: {
            id: { type: :integer },
            tile: { "$ref" => "#/components/schemas/Tile" },
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
