# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::WhatToDiscardProblems Performance Test", type: :request do
  let(:current_user) { create(:user) }
  let(:problems_query) do
    <<~GQL
      query($limit: Int) {
        whatToDiscardProblems(limit: $limit) {
          edges {
            node {
              id
              dora {
                id
                suit
                ordinalNumberInSuit
              }
              hand1 {
                id
                suit
                ordinalNumberInSuit
              }
              hand2 {
                id
                suit
                ordinalNumberInSuit
              }
              hand3 {
                id
                suit
                ordinalNumberInSuit
              }
              voteResults {
                tileId
                count
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

  let(:problem_detail_query) do
    <<~GQL
      query($id: ID!) {
        whatToDiscardProblem(id: $id) {
          id
          dora {
            id
            suit
            ordinalNumberInSuit
          }
          hand1 {
            id
            suit
            ordinalNumberInSuit
          }
          hand2 {
            id
            suit
            ordinalNumberInSuit
          }
          hand3 {
            id
            suit
            ordinalNumberInSuit
          }
          hand4 {
            id
            suit
            ordinalNumberInSuit
          }
          hand5 {
            id
            suit
            ordinalNumberInSuit
          }
          hand6 {
            id
            suit
            ordinalNumberInSuit
          }
          hand7 {
            id
            suit
            ordinalNumberInSuit
          }
          hand8 {
            id
            suit
            ordinalNumberInSuit
          }
          hand9 {
            id
            suit
            ordinalNumberInSuit
          }
          hand10 {
            id
            suit
            ordinalNumberInSuit
          }
          hand11 {
            id
            suit
            ordinalNumberInSuit
          }
          hand12 {
            id
            suit
            ordinalNumberInSuit
          }
          hand13 {
            id
            suit
            ordinalNumberInSuit
          }
          tsumo {
            id
            suit
            ordinalNumberInSuit
          }
          voteResults {
            tileId
            count
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
    GQL
  end

  def execute_problems_query(variables: {})
    post "/graphql",
      params: { query: problems_query, variables: variables },
      as: :json
  end

  def execute_problem_detail_query(variables: {})
    post "/graphql",
      params: { query: problem_detail_query, variables: variables },
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

  describe "performance improvement verification" do
    let!(:problems) { create_list(:what_to_discard_problem, 5) }

    before do
      # 各問題にvotesを作成
      problems.each do |problem|
        create_list(:what_to_discard_problem_vote, 3, what_to_discard_problem: problem)
      end
    end

    it "should execute problems list query efficiently" do
      query_count = count_queries do
        execute_problems_query(variables: { limit: 5 })
      end

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:errors]).to be_nil

      edges = json[:data][:whatToDiscardProblems][:edges]
      expect(edges.length).to eq(5)

      # DataLoaderを使用することで、大幅にクエリ数が削減されることを期待
      puts "Problems list query count: #{query_count}"
      expect(query_count).to be < 15 # DataLoader使用後の期待値
    end

    it "should execute problem detail query efficiently" do
      problem = problems.first

      query_count = count_queries do
        execute_problem_detail_query(variables: { id: problem.id.to_s })
      end

      json = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(:ok)
      expect(json[:errors]).to be_nil

      problem_data = json[:data][:whatToDiscardProblem]
      expect(problem_data[:id]).to eq(problem.id.to_s)

      puts "Problem detail query count: #{query_count}"
      expect(query_count).to be < 10 # DataLoader使用後の期待値
    end
  end

  private

    def count_queries(&block)
      query_count = 0
      callback = lambda do |*args|
        query_count += 1 unless args[4][:name] =~ /SCHEMA|TRANSACTION/
      end

      ActiveSupport::Notifications.subscribed(callback, "sql.active_record", &block)
      query_count
    end
end
