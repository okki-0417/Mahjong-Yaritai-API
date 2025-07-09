require "swagger_helper"

RSpec.describe "what_to_discard_problems/likes/my_likes", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/likes/my_like" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"

    get("show my_like") do
      tags "WhatToDiscardProblem::Like::MyLike"
      operationId "getWhatToDiscardProblemMyLike"
      produces "application/json"

      response(204, "no_content") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(200, "successful") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        before { create(:like, likable: what_to_discard_problem, user: current_user) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[my_like],
          properties: {
            my_like: { "$ref" => "#/components/schemas/Like"  },
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
      tags "WhatToDiscardProblem::Like::MyLike"
      operationId "createWhatToDiscardProblemMyLike"
      produces "application/json"

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(Like).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[what_to_discard_problem_my_like],
          properties: {
            what_to_discard_problem_my_like: { "$ref" => "#/components/schemas/Like"  },
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
      tags "WhatToDiscardProblem::Like::MyLike"
      operationId "deleteWhatToDiscardProblemMyLike"
      produces "application/json"

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        run_test!
      end

      response(204, "no_content") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { create(:like, likable: what_to_discard_problem, user: current_user) }

        run_test!
      end
    end
  end
end
