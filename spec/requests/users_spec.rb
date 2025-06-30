# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "users", type: :request do
  path "/users" do
    post("create user") do
      tags "User"
      operationId "createUser"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[user],
        properties: {
          user: {
            type: :object,
            required: %w[name avatar],
            properties: {
              name: { type: :string, maxLength: User::USER_NAME_LENGTH },
              avatar: { type: :string, format: :binary },
              password: { type: :string },
              password_confirmation: { type: :string },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
              password: "password",
              password_confirmation: "password",
            },
          }
        end

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
              password: "password",
              password_confirmation: "password",
            },
          }
        end

        before { allow_any_instance_of(User).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
              password: "password",
              password_confirmation: "password",
            },
          }
        end

        let(:authorization) { create(:authorization) }
        before { allow(Authorization).to receive(:find_by).and_return(authorization) }

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

  path "/users/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"

    get("show user") do
      tags "User"
      operationId "getUser"
      produces "application/json"

      response(200, "ok") do
        let(:id) { create(:user).id }

        schema type: :object,
          required: %w[user],
          properties: {
            user: { "$ref" => "#/components/schemas/User" },
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

    put("update user") do
      tags "User"
      operationId "updateUser"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[user],
        properties: {
          user: {
            type: :object,
            required: %w[name avatar],
            properties: {
              name: { type: :string, maxLength: User::USER_NAME_LENGTH },
              avatar: { type: :string, format: :binary },
            },
          },
        },
      }

      response(401, "unauthorized") do
        let(:id) { create(:user).id }

        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
            },
          }
        end

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:id) { current_user.id }

        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
            },
          }
        end

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(User).to receive(:update).and_return(false) }

        run_test!
      end

      response(200, "ok") do
        let(:id) { current_user.id }

        let(:request_params) do
          {
            user: {
              name: "name",
              avatar:  Rack::Test::UploadedFile.new(File.join(Rails.root,
"spec/fixtures/images/test.png")),
            },
          }
        end

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[user],
          properties: {
            user: {
              "$ref" => "#/components/schemas/User",
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

    delete("delete user") do
      tags "User"
      operationId "deleteUser"
      produces "application/json"

      response(401, "unauthorized") do
        let(:id) { create(:user).id }

        run_test!
      end

      response(204, "no_content") do
        let(:id) { current_user.id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end
    end
  end
end
