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
        let(:comment_id) { create(:comment, commentable: what_to_discard_problem).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        schema type: :object,
          required: %w[what_to_discard_problem_comment_replies],
          properties: {
            what_to_discard_problem_comment_replies: {
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

    post("create reply") do
      tags "WhatToDiscardProblem:Comment:Reply"
      operationId "createReply"
      consumes "application/json"
      produces "application/json"

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { create(:comment, commentable: what_to_discard_problem).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment_reply: {
              parent_comment_id: comment_id,
              content: "reply_content",
            },
          }
        end

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { create(:comment, commentable: what_to_discard_problem).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment_reply: {
              parent_comment_id: comment_id,
              content: "reply_content",
            },
          }
        end

        before { allow_any_instance_of(Comment).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { create(:comment, commentable: what_to_discard_problem).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment_reply: {
              parent_comment_id: comment_id,
              content: "reply_content",
            },
          }
        end

        schema type: :object,
          required: %w[what_to_discard_problem_comment_reply],
          properties: {
            what_to_discard_problem_comment_reply: {
              "$ref" => "#/components/schemas/Comment"
            }
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

  path "/what_to_discard_problems/{what_to_discard_problem_id}/comments/{comment_id}/replies/{id}" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"
    parameter name: "comment_id", in: :path, type: :string, description: "comment_id"
    parameter name: "id", in: :path, type: :string, description: "id"

    delete("delete reply") do
      tags "WhatToDiscardProblem:Comment:Reply"
      operationId "deleteReply"
      consumes "application/json"
      produces "application/json"

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { comment.id }
        let(:id) { create(:comment, commentable: what_to_discard_problem, parent_comment_id: comment.id).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }
        let(:comment) { create(:comment, commentable: what_to_discard_problem) }

        run_test!
      end

      response(204, "no_content") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { comment.id }
        let(:id) { create(:comment, commentable: what_to_discard_problem, parent_comment_id: comment.id).id }

        let(:what_to_discard_problem) { create(:what_to_discard_problem) }
        let(:comment) { create(:comment, commentable: what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in"

        run_test!
      end
    end
  end
end
