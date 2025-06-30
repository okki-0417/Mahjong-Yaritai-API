# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "what_to_discard_problems", type: :request do
  path "/what_to_discard_problems" do
    get("list what_to_discard_problems") do
      tags "WhatToDiscardProblem"
      operationId "getWhatToDiscardProblems"
      produces "application/json"

      response(200, "ok") do
        before { create_list(:what_to_discard_problem, 3) }

        schema type: :object,
          required: %w[what_to_discard_problems meta],
          properties: {
            what_to_discard_problems: {
              type: :array,
              items: { "$ref" => "#/components/schemas/WhatToDiscardProblem" },
            },
            meta: { "$ref" => "#/components/schemas/Pagination" },
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

    # post("create what_to_discard_problem") do
    #   response(200, "successful") do
    #     after do |example|
    #       example.metadata[:response][:content] = {
    #         "application/json" => {
    #           example: JSON.parse(response.body, symbolize_names: true),
    #         },
    #       }
    #     end
    #     run_test!
    #   end
    # end
  end

  # path "/what_to_discard_problems/{id}" do
  #   # You"ll want to customize the parameter types...
  #   parameter name: "id", in: :path, type: :string, description: "id"

  #   delete("delete what_to_discard_problem") do
  #     response(200, "successful") do
  #       let(:id) { "123" }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           "application/json" => {
  #             example: JSON.parse(response.body, symbolize_names: true),
  #           },
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
end
