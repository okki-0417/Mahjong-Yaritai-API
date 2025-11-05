# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Queries::BookmarkedWhatToDiscardProblems", type: :request do
  include GraphqlHelper

  describe "bookmarkedWhatToDiscardProblems" do
    subject do
      execute_query(query, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:variables) { {} }
    let(:query) do
      <<~GQL
        query {
          bookmarkedWhatToDiscardProblems {
            edges {
              node {
                id
                doraId
                hand1Id
                hand2Id
                hand3Id
                user {
                  id
                  name
                  avatarUrl
                }
                likesCount
                bookmarksCount
                votesCount
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

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ブックマークした問題がない場合" do
      it "空のedgesを返すこと" do
        json = subject

        expect(json[:errors]).to be_nil
        expect(json[:data][:bookmarkedWhatToDiscardProblems][:edges]).to eq([])
      end
    end

    context "ブックマークした問題がある場合" do
      let!(:problem1) { create(:what_to_discard_problem) }
      let!(:problem2) { create(:what_to_discard_problem) }
      let!(:problem3) { create(:what_to_discard_problem) }
      let!(:bookmark1) { create(:bookmark, user: current_user, bookmarkable: problem1) }
      let!(:bookmark2) { create(:bookmark, user: current_user, bookmarkable: problem2) }

      it "問題を返すこと" do
        json = subject

        expect(json[:errors]).to be_nil

        edges = json[:data][:bookmarkedWhatToDiscardProblems][:edges]
        expect(edges.size).to eq(2)
      end

      it "他のユーザーがブックマークした問題は返さないこと" do
        create(:bookmark, user: other_user, bookmarkable: problem3)

        json = subject

        edges = json[:data][:bookmarkedWhatToDiscardProblems][:edges]

        expect(edges.size).to eq(2)
        problem_ids = edges.map { |edge| edge[:node][:id] }
        expect(problem_ids).not_to include(problem3.id.to_s)
      end
    end
  end
end
