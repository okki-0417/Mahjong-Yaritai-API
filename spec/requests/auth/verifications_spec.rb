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

      let(:form) { Auth::VerificationForm.new(token:) }
      let(:request_params) { { auth_verification: { token: } } }
      let(:token) { "000000" }

      before do
        allow(Auth::VerificationForm).to receive(:new).and_return(form)
      end

      response(403, "forbidden") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        before { allow(form).to receive(:valid?).and_return(false) }

        schema type: :object,
          properties: {
            errors: { "$ref" => "#/components/schemas/Errors" },
          },
          required: %w[errors]

        run_test!
      end

      response(204, "ok") do
        before do
          allow(form).to receive(:valid?).and_return(true)
          allow(form).to receive(:user).and_return(nil)
          allow(form).to receive(:auth_request).and_return(create(:auth_request))
        end

        run_test!
      end

      response(201, "created") do
        before do
          allow(form).to receive(:valid?).and_return(true)
          allow(form).to receive(:user).and_return(create(:user))
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
