# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "learnings/questions", type: :request do
  path "/learnings/categories/{category_id}/questions" do
    parameter name: :category_id, in: :path, type: :string, description: "category_id"

    get("list learning questions") do
      tags "Learning::Question"
      operationId "getLearningQuestions"
      produces "application/json"

      let(:category) { create(:learning_category) }
      let(:category_id) { category.id }

      response(200, "ok") do
        before { create_list(:learning_question, 3, category: category) }

        schema type: :object,
          required: %w[learning_questions],
          properties: {
            learning_questions: {
              type: :array,
              items: { "$ref" => "#/components/schemas/LearningQuestion" },
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

  path "/learnings/categories/{category_id}/questions/{id}" do
    parameter name: :category_id, in: :path, type: :string, description: "category_id"
    parameter name: :id, in: :path, type: :string, description: "id"

    get("show learning question") do
      tags "Learning::Question"
      operationId "getLearningQuestion"
      produces "application/json"

      let(:id) { question.id }

      response(200, "ok") do
        let(:category) { create(:learning_category) }
        let(:question) { create(:learning_question, category: category) }
        let(:category_id) { category.id }

        schema type: :object,
          required: %w[learning_question],
          properties: {
            learning_question: { "$ref" => "#/components/schemas/LearningQuestion" },
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
