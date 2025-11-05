# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::WhatToDiscardProblems::Bookmarks::CreateWhatToDiscardProblemBookmark, type: :request do
  include GraphqlHelper

  describe "resolve" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:variables) { { problemId: problem.id.to_s } }
    let(:problem) { create(:what_to_discard_problem) }
    let(:mutation) do
      <<~GQL
        mutation($problemId: ID!) {
          createWhatToDiscardProblemBookmark(input: { problemId: $problemId }) {
            bookmark {
              id
              userId
              problemId
            }
          }
        }
      GQL
    end

    context "ログインしていない場合 " do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblemBookmark]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "保存に失敗した場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          bookmark = instance_double(Bookmark, save: false, errors:)
          allow(current_user.created_bookmarks).to receive(:new).and_return(bookmark)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemBookmark]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "保存に成功した場合" do
        it "ブックマークが作成できること" do
          json = subject

          bookmark_data = json[:data][:createWhatToDiscardProblemBookmark][:bookmark]
          expect(bookmark_data[:userId].to_i).to eq current_user.id
          expect(bookmark_data[:problemId].to_i).to eq problem.id
        end
      end
    end
  end
end
