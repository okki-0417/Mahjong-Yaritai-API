# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "auth/google/logins", type: :request do
  path "/auth/google/login" do
    get("show login") do
      tags "Auth::Google::Login"
      operationId "getGoogleLogin"
      produces "application/json"

      response(200, "successful") do
        schema type: :object,
          required: [ "redirect_url" ],
          properties: {
            redirect_url: { type: :string },
          }

        before do
          ENV["GOOGLE_CLIENT_ID"] = "test_client_id"
          ENV["GOOGLE_REDIRECT_URI"] = "http://localhost:3000/auth/google/callback"
        end

        after do
          ENV.delete("GOOGLE_CLIENT_ID")
          ENV.delete("GOOGLE_REDIRECT_URI")
        end

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
