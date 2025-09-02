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
  end
end
