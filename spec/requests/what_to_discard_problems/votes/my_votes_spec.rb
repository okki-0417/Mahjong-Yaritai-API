# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "what_to_discard_problems/votes/my_votes", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/votes/my_vote" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"

    get("show my_vote") do
      tags "WhatToDiscardProblem::Comment::MyVote"
      operationId "getWhatToDiscardProblemMyVote"
      produces "application/json"

      let(:what_to_discard_problem_id) { what_to_discard_problem.id }
      let(:what_to_discard_problem) { create(:what_to_discard_problem) }

      response(200, "successful") do
        before { create(:what_to_discard_problem_vote, what_to_discard_problem:, user: current_user) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[what_to_discard_problem_my_vote],
          properties: {
            what_to_discard_problem_my_vote: {
              "$ref" => "#/components/schemas/WhatToDiscardProblemVote",
              nullable: true,
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

    post("create my_like") do
      tags "WhatToDiscardProblem::Vote::MyVote"
      operationId "createWhatToDiscardProblemMyVote"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[what_to_discard_problem_my_vote],
        properties: {
          what_to_discard_problem_my_vote: {
            type: :object,
            required: %w[tile_id],
            properties: {
              tile_id: { type: :integer },
            },
          },
        },
      }

      let(:what_to_discard_problem_id) { what_to_discard_problem.id }
      let(:what_to_discard_problem) { create(:what_to_discard_problem) }
      let(:request_params) { { what_to_discard_problem_my_vote: { tile_id: create(:tile).id } } }

      response(401, "unauthorized") do
        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before do
          allow_any_instance_of(WhatToDiscardProblem::Vote).to receive(:save).and_return(false)
        end

        run_test!
      end

      response(201, "created") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[what_to_discard_problem_my_vote],
          properties: {
            what_to_discard_problem_my_vote: { "$ref" => "#/components/schemas/WhatToDiscardProblemVote"  },
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

    delete("delete my_like") do
      tags "WhatToDiscardProblem::Like::MyVote"
      operationId "deleteWhatToDiscardProblemMyVote"
      produces "application/json"

      let(:what_to_discard_problem_id) { what_to_discard_problem.id }
      let(:what_to_discard_problem) { create(:what_to_discard_problem) }

      response(401, "unauthorized") do
        run_test!
      end

      response(204, "no_content") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { create(:what_to_discard_problem_vote, what_to_discard_problem:, user: current_user) }

        run_test!
      end
    end
  end
end
