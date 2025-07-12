# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "me/withdrawals", type: :request do
  path "/me/withdrawal" do
    post("create user") do
      tags "Me::Withdrawal"
      operationId "withdrawUser"
      produces "application/json"

      response(401, "unauthorized") do
        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(User).to receive(:destroy!).and_raise(ActiveRecord::RecordNotDestroyed.new("Failed")) }

        run_test!
      end

      response(204, "no_content") do
        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        run_test!
      end
    end
  end
end
