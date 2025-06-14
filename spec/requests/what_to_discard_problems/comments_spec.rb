require "swagger_helper"

RSpec.describe "what_to_discard_problems/comments", type: :request do

  path "/what_to_discard_problems/{what_to_discard_problem_id}/comments" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string

    get("list comments") do
      tags "WhatToDiscardProblem::Comment"
      operationId "getComments"
      produces "application/json"

      response(200, "successful") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        before { create(:comment, commentable: what_to_discard_problem) }

        schema type: :object,
          required: %w[what_to_discard_problem_comments],
          properties: {
            what_to_discard_problem_comments: {
              type: :array,
              items: { "$ref" => "#/components/schemas/Comment" }
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

    post("create comment") do
      tags "WhatToDiscardProblem::Comment"
      operationId "createComment"
      consumes "application/json"
      produces "application/json"

      response(401, "unauthorized") do
        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment:{
              content: "comment_content",
              parent_comment_id: nil
            }
          }
        end

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment:{
              content: "comment_content",
              parent_comment_id: nil
            }
          }
        end

        before { allow_any_instance_of(Comment).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        let(:what_to_discard_problem_id) { create(:what_to_discard_problem).id }

        parameter name: :params, in: :body
        let(:params) do
          {
            what_to_discard_problem_comment:{
              content: "comment_content",
              parent_comment_id: nil
            }
          }
        end

        schema type: :object,
          required: %w[what_to_discard_problem_comment],
          properties: {
            what_to_discard_problem_comment: {
            "$ref" => "#/components/schemas/Comment",
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

  path "/what_to_discard_problems/{what_to_discard_problem_id}/comments/{id}" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string
    parameter name: "id", in: :path, type: :string

    delete("Delete Comment") do
      tags "WhatToDiscardProblem::Comment"
      operationId "deleteComment"
      consumes "application/json"

      response(401, "unauthorized") do
        let(:id) { create(:comment, commentable: what_to_discard_problem).id }
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        run_test!
      end

      response(204, "no_content") do
        let(:id) { create(:comment, commentable: what_to_discard_problem, user: current_user).id }
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end
    end
  end
end
