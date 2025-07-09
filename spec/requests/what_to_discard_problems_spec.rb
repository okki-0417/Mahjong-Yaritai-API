# frozen_string_literal: true

require "swagger_helper"

RSpec.describe "what_to_discard_problems", type: :request do
  path "/what_to_discard_problems" do
    get("list what_to_discard_problems") do
      tags "WhatToDiscardProblem"
      operationId "getWhatToDiscardProblems"
      produces "application/json"

      response(200, "ok") do
        before { create_list(:what_to_discard_problem, 3) }

        schema type: :object,
          required: %w[what_to_discard_problems meta],
          properties: {
            what_to_discard_problems: {
              type: :array,
              items: { "$ref" => "#/components/schemas/WhatToDiscardProblem" },
            },
            meta: {
              pagination: { "$ref" => "#/components/schemas/Pagination"  },
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

    post("create what_to_discard_problem") do
      tags "WhatToDiscardProblem"
      operationId "createWhatToDiscardProblem"
      consumes "application/json"
      produces "application/json"
      parameter name: :request_params, in: :body, schema: {
        type: :object,
        required: %w[what_to_discard_problem],
        properties: {
          what_to_discard_problem: {
            type: :object,
            required: %w[round turn wind dora_id point_east point_south point_west point_north hand1_id hand2_id hand3_id hand4_id hand5_id hand6_id hand7_id hand8_id hand9_id hand10_id hand11_id hand12_id hand13_id tsumo_id],
            properties: {
              round: { type: :string },
              turn: { type: :integer },
              wind: { type: :string },
              dora_id: { type: :integer },
              point_east: { type: :integer },
              point_south: { type: :integer },
              point_west: { type: :integer },
              point_north: { type: :integer },
              hand1_id: { type: :integer },
              hand2_id: { type: :integer },
              hand3_id: { type: :integer },
              hand4_id: { type: :integer },
              hand5_id: { type: :integer },
              hand6_id: { type: :integer },
              hand7_id: { type: :integer },
              hand8_id: { type: :integer },
              hand9_id: { type: :integer },
              hand10_id: { type: :integer },
              hand11_id: { type: :integer },
              hand12_id: { type: :integer },
              hand13_id: { type: :integer },
              tsumo_id: { type: :integer },
            },
          },
        },
      }

      response(201, "created") do
        let(:request_params) do
          {
            round: "東一",
            turn: 1,
            wind: "東",
            dora_id: create(:tile).id,
            point_east: create(:tile).id,
            point_south: create(:tile).id,
            point_west: create(:tile).id,
            point_north: create(:tile).id,
            hand1_id: create(:tile).id,
            hand2_id: create(:tile).id,
            hand3_id: create(:tile).id,
            hand4_id: create(:tile).id,
            hand5_id: create(:tile).id,
            hand6_id: create(:tile).id,
            hand7_id: create(:tile).id,
            hand8_id: create(:tile).id,
            hand9_id: create(:tile).id,
            hand10_id: create(:tile).id,
            hand11_id: create(:tile).id,
            hand12_id: create(:tile).id,
            hand13_id: create(:tile).id,
            tsumo_id: create(:tile).id,
          }
        end

        schema type: :object,
          required: %w[what_to_discard_problem],
          properties: {
            what_to_discard_problem: { "$ref" => "#/components/schemas/WhatToDiscardProblem" },
          }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end

      response(401, "unauthorized") do
        let(:request_params) do
          {
            round: "東一",
            turn: 1,
            wind: "東",
            dora_id: create(:tile).id,
            point_east: create(:tile).id,
            point_south: create(:tile).id,
            point_west: create(:tile).id,
            point_north: create(:tile).id,
            hand1_id: create(:tile).id,
            hand2_id: create(:tile).id,
            hand3_id: create(:tile).id,
            hand4_id: create(:tile).id,
            hand5_id: create(:tile).id,
            hand6_id: create(:tile).id,
            hand7_id: create(:tile).id,
            hand8_id: create(:tile).id,
            hand9_id: create(:tile).id,
            hand10_id: create(:tile).id,
            hand11_id: create(:tile).id,
            hand12_id: create(:tile).id,
            hand13_id: create(:tile).id,
            tsumo_id: create(:tile).id,
          }
        end
        run_test!
      end

      response(422, :unprocessable_entity) do
        let(:request_params) do
          {
            round: "東一",
            turn: 1,
            wind: "東",
            dora_id: create(:tile).id,
            point_east: create(:tile).id,
            point_south: create(:tile).id,
            point_west: create(:tile).id,
            point_north: create(:tile).id,
            hand1_id: create(:tile).id,
            hand2_id: create(:tile).id,
            hand3_id: create(:tile).id,
            hand4_id: create(:tile).id,
            hand5_id: create(:tile).id,
            hand6_id: create(:tile).id,
            hand7_id: create(:tile).id,
            hand8_id: create(:tile).id,
            hand9_id: create(:tile).id,
            hand10_id: create(:tile).id,
            hand11_id: create(:tile).id,
            hand12_id: create(:tile).id,
            hand13_id: create(:tile).id,
            tsumo_id: create(:tile).id,
          }
        end

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"

        before { allow_any_instance_of(WhatToDiscardProblem).to receive(:save).and_return(false) }
      end
    end
  end

  path "/what_to_discard_problems/{id}" do
    parameter name: "id", in: :path, type: :string, description: "id"

    delete("delete what_to_discard_problem") do
      tags "WhatToDiscardProblem"
      operationId "deleteWhatToDiscardProblem"

      response(401, "unauthorized") do
        let(:id) { create(:what_to_discard_problem).id }
        run_test!
      end

      response(422, "unprocessable_entity") do
        let(:id) { create(:what_to_discard_problem, user: current_user).id }

        let(:current_user) { create(:user) }
        include_context "logged_in_rswag"
      end
    end
  end
end
