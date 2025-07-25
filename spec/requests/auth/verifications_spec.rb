# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "auth/verifications", type: :request do
  path "/auth/verification" do
    post("create auth_verification") do
      tags "Auth::Verification"
      operationId "createAuthVerification"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[auth_verification],
        properties: {
          auth_verification: {
            type: :object,
            required: %w[token],
            properties: {
              token: { type: :string },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) { { auth_verification: { token: } } }
        let(:token) { "000000" }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:request_params) { { auth_verification: { token: } } }
        let(:token) { "000000" }

        before { allow(AuthRequest).to receive(:find_by).and_return(nil) }

        schema type: :object,
               properties: {
                 errors: {
                   "$ref" => "#/components/schemas/Errors",
                 },
               },
               required: %w[errors]

        run_test!
      end

      response(204, "ok") do
        let(:request_params) { { auth_verification: { token: } } }
        let(:token) { authorization.token }
        let!(:authorization) { create(:auth_request) }

        run_test!
      end

      response(201, "created") do
        let(:request_params) { { auth_verification: { token: } } }
        let(:token) { authorization.token }
        let!(:authorization) { create(:auth_request, email: user.email) }
        let!(:user) { create(:user) }

        schema type: :object,
               properties: {
                 auth_verification: {
                   "$ref" => "#/components/schemas/User",
                 },
               },
               required: %w[auth_verification]

        run_test!
      end
    end
  end
end
