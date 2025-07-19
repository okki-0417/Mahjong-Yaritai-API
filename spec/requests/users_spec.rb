# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "users", type: :request do
  path "/users" do
    post("create user") do
      tags "User"
      operationId "createUser"
      consumes "multipart/form-data"
      produces "application/json"
      parameter name: :name, in: :formData, schema: {
        type: :object,
        required: %w[name avatar],
        properties: {
          name: { type: :string, maxLength: User::USER_NAME_LENGTH },
          avatar: { type: :string, format: :binary },
        },
      }

      response(403, "forbidden") do
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

        before { allow_any_instance_of(User).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

        let(:auth_request) { create(:auth_request) }
        before { allow(AuthRequest).to receive(:find_by).and_return(auth_request) }

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
      consumes "multipart/form-data"
      produces "application/json"
      parameter name: :name, in: :formData, schema: {
        type: :object,
        required: %w[name],
        properties: {
          name: { type: :string, minLength: 1, maxLength: User::USER_NAME_LENGTH },
          avatar: { type: :string, format: :binary },
        },
      }

      response(401, "unauthorized") do
        let(:id) { create(:user).id }
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:id) { current_user.id }
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(User).to receive(:update).and_return(false) }

        run_test!
      end

      response(200, "ok") do
        let(:id) { current_user.id }
        let(:name) { "name" }
        let(:avatar) { fixture_file_upload(File.join(Rails.root, "spec/fixtures/images/test.png")) }

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
