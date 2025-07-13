# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "auth_requests", type: :request do
  path "/auth/request" do
    post("create auth_request") do
      tags "Auth::Request"
      operationId "createAuthRequest"
      consumes "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[auth_request],
        properties: {
          auth_request: {
            type: :object,
            required: %w[email],
            properties: {
              email: { type: :string, maxLength: AuthRequest::EMAIL_LENGTH },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) { { auth_request: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:request_params) { { auth_request: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        before { allow_any_instance_of(AuthRequest).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:request_params) { { auth_request: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        run_test!
      end
    end
  end
end
