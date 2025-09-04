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

      let(:request_params) { { auth_verification: { token: } } }
      let(:token) { "000000" }

      let(:auth_request) { create(:auth_request, token:) }
      before { allow(AuthRequest).to receive(:find_by).and_return(auth_request) }

      response(403, "forbidden") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        before { allow(auth_request).to receive(:within_valid_period?).and_return(false) }

        schema type: :object,
          properties: {
            errors: { "$ref" => "#/components/schemas/Errors" },
          },
          required: %w[errors]

        run_test!
      end

      response(204, "ok") do
        before do
          allow(auth_request).to receive(:within_valid_period?).and_return(true)
          allow(auth_request).to receive(:requested_user).and_return(nil)
        end

        run_test!
      end

      response(201, "created") do
        before do
          user = create(:user, email: auth_request.email)
          allow(auth_request).to receive(:within_valid_period?).and_return(true)
          allow(auth_request).to receive(:requested_user).and_return(user)
        end

        schema type: :object,
          required: %w[user],
          properties: {
            user: { "$ref" => "#/components/schemas/User" },
          }

        run_test!
      end
    end
  end
end
