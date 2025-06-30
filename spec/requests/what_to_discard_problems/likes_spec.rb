require "swagger_helper"

RSpec.describe "what_to_discard_problems/likes", type: :request do
  path "/what_to_discard_problems/{what_to_discard_problem_id}/likes" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, required: true

    post "Create Like" do
      tags "WhatToDiscardProblem::Like"
      operationId "createWhatToDiscardProblemLike"
      consumes "application/json"
      produces "application/json"

      response(401, "not_logged_in") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(Like).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        schema type: :object,
          required: %w[what_to_discard_problem_like],
          properties: {
            what_to_discard_problem_like: { "$req" => "#/components/schemas/Like" },
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

  path "/what_to_discard_problems/{what_to_discard_problem_id}/likes/{id}" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, required: true
    parameter name: "id", in: :path, type: :string, required: true

    delete "Delete Like" do
      tags "WhatToDiscardProblem::Like"
      operationId "deleteWhatToDiscardProblemLike"

      response(401, "not_logged_in") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:id) { create(:like, likable: what_to_discard_problem).id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        run_test!
      end

      response(204, "no_content") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }
        let(:id) { create(:like, likable: what_to_discard_problem, user: current_user).id }

        run_test!
      end
    end
  end
end
