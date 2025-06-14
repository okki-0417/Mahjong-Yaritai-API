require "swagger_helper"

RSpec.describe "what_to_discard_problems/comments/replies", type: :request do

  path "/what_to_discard_problems/{what_to_discard_problem_id}/comments/{comment_id}/replies" do
    parameter name: "what_to_discard_problem_id", in: :path, type: :string
    parameter name: "comment_id", in: :path, type: :string

    get("list replies") do
      response(200, "successful") do
        let(:what_to_discard_problem_id) { what_to_discard_problem.id }
        let(:comment_id) { create(:what_to_discard_problem_comment, what_to_discard_problem:).id }
        let(:what_to_discard_problem) { create(:what_to_discard_problem) }

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

  #   post("create reply") do
  #     response(201, "created") do
  #       let(:what_to_discard_problem_id) { what_to_discard_problem.id }
  #       let(:comment_id) { create(:what_to_discard_problem_comment, what_to_discard_problem:).id }
  #       let(:what_to_discard_problem) { create(:what_to_discard_problem) }

  #       let(:current_user) { create(:user) }
  #       include_context "logged_in_rswag"

  #       parameter name: :params, in: :body
  #       let(:params) do
  #         {
  #           what_to_discard_problem_comment_reply: {
  #             parent_id: comment_id,
  #             content: "reply_content",
  #           },
  #         }
  #       end

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end

  # path "/what_to_discard_problems/{what_to_discard_problem_id}/comments/{comment_id}/replies/{id}" do
  #   # You"ll want to customize the parameter types...
  #   parameter name: "what_to_discard_problem_id", in: :path, type: :string, description: "what_to_discard_problem_id"
  #   parameter name: "comment_id", in: :path, type: :string, description: "comment_id"
  #   parameter name: "id", in: :path, type: :string, description: "id"

  #   delete("delete reply") do
  #     response(200, "successful") do
  #       let(:what_to_discard_problem_id) { "123" }
  #       let(:comment_id) { "123" }
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end
