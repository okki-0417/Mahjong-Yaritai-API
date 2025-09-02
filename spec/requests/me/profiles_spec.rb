# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "Me::ProfilesController", type: :request do
  path "/me/profile" do
    get "get profile" do
      tags "Profile"
      operationId "getProfile"
      produces "application/json"

      response 401, "unauthorized" do
        run_test!
      end

      response 200, "successful" do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        schema type: :object,
          required: %w[profile],
          properties: {
            profile: {
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

    put "update user" do
      tags "User"
      operationId "updateUser"
      consumes "multipart/form-data"
      produces "application/json"
      parameter name: :name, in: :formData, schema: {
        type: :object,
        required: %w[name],
        properties: {
          name: { type: :string, minLength: 1, maxLength: User::USER_NAME_LENGTH },
          profile_text: { type: :string, maxLength: User::PROFILE_TEXT_LENGTH },
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
  end
end
