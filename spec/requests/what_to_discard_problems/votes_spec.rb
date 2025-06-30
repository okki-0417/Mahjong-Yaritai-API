# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "what_to_discard_problems/votes", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/votes" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string,
description: "what_to_discard_problem_id"

    post("create vote") do
      tags "WhatToDiscardProblem::Vote"
      operationId "createVote"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[what_to_discard_problem_vote],
        properties: {
          what_to_discard_problem_vote: {
            type: :object,
            required: %w[tile_id],
            properties: {
              tile_id: { type: :string },
            },
          },
        },
      }

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        let(:request_params) do
          {
            what_to_discard_problem_vote: {
              tile_id:,
            },
          }
        end
        let(:tile_id) { create(:tile).id }

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }
        let(:request_params) do
          {
            what_to_discard_problem_vote: {
              tile_id:,
            },
          }
        end
        let(:tile_id) { create(:tile).id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(WhatToDiscardProblem::Vote).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        let(:request_params) do
          {
            what_to_discard_problem_vote: {
              tile_id:,
            },
          }
        end
        let(:tile_id) { create(:tile).id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[what_to_discard_problem_vote],
          properties: {
            what_to_discard_problem_vote: {
              "$ref" => "#/components/schemas/WhatToDiscardProblemVote",
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

  path "/what_to_discard_problems/{what_to_discard_problem_id}/votes/{id}" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string,
description: "what_to_discard_problem_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    delete("delete vote") do
      tags "WhatToDiscardProblem::Vote"
      operationId "deleteVote"

      response(204, "no_content") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }
        let(:id) {
 create(:what_to_discard_problem_vote, what_to_discard_problem:, user: current_user).id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end
    end
  end
end
