# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "users/followers", type: :request do
  let(:user) { create(:user) }
  let(:user_id) { user.id }

  path "/users/{user_id}/followers" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    get("list followers") do
      tags "Follow"
      operationId "getUserFollowers"
      produces "application/json"

      parameter name: :cursor, in: :query, type: :string, required: false, description: "Cursor for pagination"
      parameter name: :limit, in: :query, type: :string, required: false, description: "Number of items per page (max 100)"

      response(200, "ok") do
        before { create_list(:follow, 3, followee: user) }

        schema type: :object,
          required: %w[users meta],
          properties: {
            users: {
              type: :array,
              items: { "$ref" => "#/components/schemas/User" },
            },
            meta: { "$ref" => "#/components/schemas/Meta" },
          }

        run_test!
      end
    end
  end
end
