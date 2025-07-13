# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "sessions", type: :request do
  path "/session" do
    get("show session") do
      tags "Session"
      operationId "getSession"
      produces "application/json"

      response(200, "successful") do
        let(:current_user) { create(:user) }
        include_context "logged_in"

        schema type: :object,
          required: %w[session],
          properties: {
            session: { "$ref" => "#/components/schemas/Session" },
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

    delete("delete session") do
      tags "Session"
      operationId "deleteSession"
      produces "application/json"

      response(401, "unauthorized") do
        schema type: :object,
        required: %w[errors],
          properties: {
            errors: { "$ref" => "#/components/schemas/Errors" },
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

      response(204, "no_content") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end
    end
  end
end
