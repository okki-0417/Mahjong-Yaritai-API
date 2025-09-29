# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::WhatToDiscardProblems N+1 Prevention", type: :request do
  let(:current_user) { create(:user) }
  let(:query) do
    <<~GQL
      query($limit: Int) {
        whatToDiscardProblems(limit: $limit) {
          edges {
            node {
              id
              isLikedByMe
              isBookmarkedByMe
              myVote {
                id
                tileId
              }
              voteResults {
                tileId
                count
                percentage
                tile {
                  id
                  suit
                  ordinalNumberInSuit
                }
              }
              user {
                id
                name
                avatarUrl
              }
            }
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

  before do
    # セッションベースの認証をセットアップ
    post "/auth/verification",
      params: { token: "123456", email: current_user.email },
      as: :json

    # セッションを手動で設定
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(current_user)
  end

  describe "N+1 prevention test" do
    let!(:problems) { create_list(:what_to_discard_problem, 3) }

    before do
      # 各問題にvotes, likes, bookmarksを作成
      problems.each do |problem|
        create_list(:what_to_discard_problem_vote, 2, what_to_discard_problem: problem)
        create(:like, likable: problem, user: current_user) # 現在ユーザーのlike
        create(:bookmark, bookmarkable: problem, user: current_user) # 現在ユーザーのbookmark
        create(:what_to_discard_problem_vote, what_to_discard_problem: problem, user: current_user) # 現在ユーザーのvote
      end
    end

    it "returns user-specific data correctly" do
      execute_query(variables: { limit: 10 })

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:errors]).to be_nil

      edges = json[:data][:whatToDiscardProblems][:edges]
      expect(edges.length).to eq(3)

      # 各問題で適切にフィールドが取得できることを確認
      edges.each do |edge|
        node = edge[:node]
        expect(node[:isLikedByMe]).to eq(true)
        expect(node[:isBookmarkedByMe]).to eq(true)
        expect(node[:myVote]).to be_present
        expect(node[:voteResults]).to be_present
        expect(node[:user]).to be_present
      end
    end
  end
end
