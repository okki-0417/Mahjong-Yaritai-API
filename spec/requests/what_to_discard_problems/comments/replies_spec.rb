require "swagger_helper"

RSpec.describe "what_to_discard_problems/comments/replies", type: :request do

  path "/what_to_discard_problems/{what_to_discard_problem_id}/comments/{comment_id}/replies" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string
    parameter name: "comment_id", in: :path, type: :string

    get("list replies") do
      tags "WhatToDiscardProblem:Comment:Reply"
      operationId "getReplies"
      produces "application/json"

      response(200, "successful") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { comment.id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }
        let(:comment) { create(:comment, commentable: what_to_discard_problem) }

        before { create(:comment, commentable: what_to_discard_problem, parent_comment_id: comment.id) }

        schema type: :object,
          required: %w[comments],
          properties: {
            comments: {
              type: :array,
              items: { "$ref" => "#/components/schemas/Comment" },
            },
          }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
