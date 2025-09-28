# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GraphQL", type: :request do
  describe "bookmarkedWhatToDiscardProblems query" do
    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:problem1) { create(:what_to_discard_problem, user: other_user) }
    let!(:problem2) { create(:what_to_discard_problem, user: other_user) }
    let!(:problem3) { create(:what_to_discard_problem, user: other_user) }

    let(:query) do
      <<~GRAPHQL
        query BookmarkedWhatToDiscardProblems($limit: Int, $cursor: String) {
          bookmarkedWhatToDiscardProblems(limit: $limit, cursor: $cursor) {
            edges {
              node {
                id
                user {
                  id
                  name
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
      GRAPHQL
    end

    before do
      allow_any_instance_of(GraphqlController).to receive(:current_user).and_return(current_user)
    end

    context "when user has bookmarked problems" do
      before do
        create(:bookmark, user: current_user, bookmarkable: problem1)
        create(:bookmark, user: current_user, bookmarkable: problem3)
      end

      it "returns bookmarked problems" do
        post "/graphql", params: { query: query }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        edges = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "edges")

        expect(edges.size).to eq(2)

        returned_problem_ids = edges.map { |edge| edge.dig("node", "id") }
        expect(returned_problem_ids).to match_array([ problem1.id.to_s, problem3.id.to_s ])
      end

      it "supports limit parameter" do
        post "/graphql", params: {
          query: query,
          variables: { limit: 1 }.to_json,
        }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        edges = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "edges")
        page_info = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "pageInfo")

        expect(edges&.size).to eq(1)
        expect(page_info["hasNextPage"]).to be true
        expect(page_info["endCursor"]).to be_present
      end

      it "supports cursor-based pagination" do
        # First request to get the first item and cursor
        post "/graphql", params: {
          query: query,
          variables: { limit: 1 }.to_json,
        }

        json_response = JSON.parse(response.body)
        first_cursor = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "pageInfo", "endCursor")

        # Second request with cursor
        post "/graphql", params: {
          query: query,
          variables: { limit: 1, cursor: first_cursor }.to_json,
        }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        edges = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "edges")
        page_info = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "pageInfo")

        expect(edges&.size).to eq(1)
        expect(page_info["hasNextPage"]).to be false
      end
    end

    context "when user has no bookmarks" do
      it "returns empty result" do
        post "/graphql", params: { query: query }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        edges = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "edges")
        page_info = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "pageInfo")

        expect(edges).to be_empty
        expect(page_info["hasNextPage"]).to be false
        expect(page_info["endCursor"]).to be_nil
      end
    end

    context "when user is not authenticated" do
      let(:current_user) { nil }

      it "returns empty result" do
        post "/graphql", params: { query: query }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        edges = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "edges")
        page_info = json_response.dig("data", "bookmarkedWhatToDiscardProblems", "pageInfo")

        expect(edges).to be_empty
        expect(page_info["hasNextPage"]).to be false
        expect(page_info["endCursor"]).to be_nil
      end
    end
  end
end
