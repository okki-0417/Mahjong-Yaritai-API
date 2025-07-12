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

    post("create session") do
      tags "Session"
      operationId "createSession"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[session],
        properties: {
          session: {
            type: :object,
            required: %w[email password],
            properties: {
              email: { type: :string },
              password: { type: :string },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) { { session: { email:, password: } } }

        let(:user) { create(:user, email:, password:) }
        let(:email) { "test@mahjong-yaritai.com" }
        let(:password) { "password" }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

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

      response(422, "unprocessable_entity") do
        let(:request_params) { { session: { email:, password: } } }

        before { create(:user, email:, password:) }
        let(:email) { "test@mahjong-yaritai.com" }
        let(:password) { "password" }

        before { allow_any_instance_of(User).to receive(:authenticate).and_return(false) }

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

      response(201, "successful") do
        let(:request_params) { { session: { email:, password: } } }

        let(:user) { create(:user, email:, password:) }
        let(:email) { "test@mahjong-yaritai.com" }
        let(:password) { "password" }

        before { allow(User).to receive(:find_by!).and_return(user) }

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
  end
end
