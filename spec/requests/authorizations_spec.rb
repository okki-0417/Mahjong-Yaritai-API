# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "authorizations", type: :request do
  path "/authorization" do
    post("create authorization") do
      tags "Authorization"
      operationId "createAuthorization"
      consumes "application/json"
      produces "applications/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[authorization],
        properties: {
          authorization: {
            type: :object,
            required: %w[token],
            properties: {
              token: { type: :string },
            },
          },
        },
      }

      response(403, "forbidden") do
        let(:request_params) { { authorization: { token: } } }
        let(:token) { "000000" }

        let(:current_user) { create(:user) }
        include_context "logged_in"

        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:request_params) { { authorization: { token: } } }
        let(:token) { "000000" }

        before { allow(Authorization).to receive(:find_by).and_return(nil) }

        run_test!
      end

      response(200, "ok") do
        let(:request_params) { { authorization: { token: } } }
        let(:token) { authorization.token }
        let!(:authorization) { create(:authorization) }

        run_test!
      end
    end
  end
end
