# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::WhatToDiscardProblems", type: :request do
  let(:query) do
    <<~GQL
      query($limit: Int, $cursor: String) {
        whatToDiscardProblems(limit: $limit, cursor: $cursor) {
          edges {
            node {
              id
              round
              turn
              wind
              points
              description
              user {
                id
                name
                avatarUrl
              }
            }
            cursor
          }
          pageInfo {
            hasNextPage
            endCursor
          }
        }
      }
    GQL
  end

  def execute_query(variables: {})
    post "/graphql",
      params: { query: query, variables: variables },
      as: :json
  end

  describe "whatToDiscardProblems" do
    context "when no problems exist" do
      it "returns empty edges" do
        execute_query

        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(json[:data][:whatToDiscardProblems][:edges]).to eq([])
        expect(json[:data][:whatToDiscardProblems][:pageInfo]).to include(
          hasNextPage: false,
          endCursor: nil
        )
      end
    end

    context "when problems exist" do
      let!(:problems) { create_list(:what_to_discard_problem, 3).sort_by(&:id).reverse }

      it "returns problems in descending order" do
        execute_query(variables: { limit: 10 })

        json = JSON.parse(response.body, symbolize_names: true)
        edges = json[:data][:whatToDiscardProblems][:edges]

        expect(response).to have_http_status(:ok)
        expect(edges.length).to eq(3)
        expect(edges[0][:node][:id]).to eq(problems[0].id.to_s)
        expect(edges[1][:node][:id]).to eq(problems[1].id.to_s)
        expect(edges[2][:node][:id]).to eq(problems[2].id.to_s)
      end

      it "includes user information" do
        execute_query(variables: { limit: 1 })

        json = JSON.parse(response.body, symbolize_names: true)
        user = json[:data][:whatToDiscardProblems][:edges][0][:node][:user]

        expect(user).to include(
          id: problems[0].user.id.to_s,
          name: problems[0].user.name
        )
      end
    end

    context "with pagination" do
      let!(:problems) { create_list(:what_to_discard_problem, 5).sort_by(&:id).reverse }

      it "returns first 2 items and hasNextPage: true" do
        execute_query(variables: { limit: 2 })

        json = JSON.parse(response.body, symbolize_names: true)
        edges = json[:data][:whatToDiscardProblems][:edges]
        page_info = json[:data][:whatToDiscardProblems][:pageInfo]

        expect(edges.length).to eq(2)
        expect(page_info[:hasNextPage]).to eq(true)
        expect(page_info[:endCursor]).to be_present
      end

      it "returns next page using cursor" do
        execute_query(variables: { limit: 2 })
        first_json = JSON.parse(response.body, symbolize_names: true)
        cursor = first_json[:data][:whatToDiscardProblems][:pageInfo][:endCursor]

        execute_query(variables: { limit: 2, cursor: cursor })
        json = JSON.parse(response.body, symbolize_names: true)
        edges = json[:data][:whatToDiscardProblems][:edges]

        expect(edges.length).to eq(2)
        expect(edges[0][:node][:id]).to eq(problems[2].id.to_s)
        expect(edges[1][:node][:id]).to eq(problems[3].id.to_s)
      end

      it "returns hasNextPage: false on last page" do
        execute_query(variables: { limit: 4 })
        first_json = JSON.parse(response.body, symbolize_names: true)
        cursor = first_json[:data][:whatToDiscardProblems][:pageInfo][:endCursor]

        execute_query(variables: { limit: 2, cursor: cursor })
        json = JSON.parse(response.body, symbolize_names: true)
        page_info = json[:data][:whatToDiscardProblems][:pageInfo]

        expect(page_info[:hasNextPage]).to eq(false)
      end
    end

    context "with limit validation" do
      before { create_list(:what_to_discard_problem, 3) }

      it "defaults to 20 when limit is not provided" do
        execute_query

        json = JSON.parse(response.body, symbolize_names: true)
        edges = json[:data][:whatToDiscardProblems][:edges]

        expect(edges.length).to eq(3)
      end

      it "limits to 100 items max" do
        execute_query(variables: { limit: 200 })

        json = JSON.parse(response.body, symbolize_names: true)
        edges = json[:data][:whatToDiscardProblems][:edges]

        expect(edges.length).to eq(3)
      end
    end
  end
end
