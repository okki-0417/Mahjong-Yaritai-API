# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "authorization_sessions", type: :request do
  path "/authorization_session" do
    post("create authorization_session") do
      tags "AuthorizationSession"
      operationId "createAuthorizationSession"
      consumes "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[authorization_session],
        properties: {
          authorization_session: {
            type: :object,
            required: %w[email],
            properties: {
              email: { type: :string, maxLength: Authorization::EMAIL_LENGTH },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) { { authorization_session: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:request_params) { { authorization_session: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        before { allow_any_instance_of(Authorization).to receive(:save).and_return(false) }

        run_test!
      end

      response(201, "created") do
        let(:request_params) { { authorization_session: { email: } } }
        let(:email) { "test@mahjong-yaritai.com" }

        run_test!
      end
    end
  end
end
