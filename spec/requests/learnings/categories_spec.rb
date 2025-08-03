# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "learnings/categories", type: :request do
  path "/learnings/categories" do
    get("list learning categories") do
      tags "Learning::Category"
      operationId "getLearningCategories"
      produces "application/json"

      response(200, "ok") do
        before { create_list(:learning_category, 3) }

        schema type: :object,
          required: %w[learning_categories],
          properties: {
            learning_categories: {
              type: :array,
              items: { "$ref" => "#/components/schemas/LearningCategory" },
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

  path "/learnings/categories/{id}" do
    parameter name: :id, in: :path, type: :string, description: "id"

    get("show learning category") do
      tags "Learning::Category"
      operationId "getLearningCategory"
      produces "application/json"

      response(200, "ok") do
        let(:id) { create(:learning_category).id }

        schema type: :object,
          required: %w[learning_category],
          properties: {
            learning_category: { "$ref" => "#/components/schemas/LearningCategory" },
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
