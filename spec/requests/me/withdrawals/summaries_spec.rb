# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "me/withdrawals/summaries", type: :request do
  path "/me/withdrawal/summary" do
    get("show withdrawal summary") do
      tags "Me::Withdrawals::summary"
      operationId "getWithdrawalSummary"
      produces "application/json"

      response(401, "unauthorized") do
        schema type: :object,
               properties: {
                 errors: {
                   "$ref" => "#/components/schemas/Errors",
                 },
               },
               required: %w[errors]

        run_test!
      end

      response(200, "ok") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before do
          create_list(:what_to_discard_problem, 3, user: current_user)
        end

        schema type: :object,
               required: %w[withdrawal_summary],
               properties: {
                 withdrawal_summary: {
                   "$ref" => "#/components/schemas/WithdrawalSummary",
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
