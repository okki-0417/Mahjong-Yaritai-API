# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "users/follows", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_id) { other_user.id }

  path "/users/{user_id}/follow" do
    parameter name: :user_id, in: :path, type: :string, description: "User ID"

    post("create follow") do
      tags "Follow"
      operationId "createFollow"
      consumes "application/json"
      produces "application/json"

      response(201, "created") do
        let(:current_user) { user }
        include_context "logged_in_rswag"

        schema type: :object,
          properties: {
            message: { type: :string },
          }

        run_test!
      end

      response(401, "unauthorized") do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  message: { type: :string },
                },
              },
            },
          }

        run_test!
      end

      response(422, "unprocessable entity") do
        let(:current_user) { user }
        include_context "logged_in_rswag"

        before do
          create(:follow, follower: user, followee: other_user)
        end

        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string },
            },
          }

        run_test!
      end
    end

    delete("delete follow") do
      tags "Follow"
      operationId "deleteFollow"
      produces "application/json"

      response(200, "ok") do
        let(:current_user) { user }
        include_context "logged_in_rswag"

        before do
          create(:follow, follower: user, followee: other_user)
        end

        schema type: :object,
          properties: {
            message: { type: :string },
          }

        run_test!
      end

      response(401, "unauthorized") do
        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  message: { type: :string },
                },
              },
            },
          }

        run_test!
      end

      response(404, "not found") do
        let(:current_user) { user }
        include_context "logged_in_rswag"

        schema type: :object,
          properties: {
            errors: {
              type: :array,
              items: { type: :string },
            },
          }

        run_test!
      end
    end
  end
end
