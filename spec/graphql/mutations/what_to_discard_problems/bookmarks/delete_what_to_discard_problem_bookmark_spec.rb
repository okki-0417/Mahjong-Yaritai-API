# frozen_string_literal: true

require "rails_helper"

RSpec.describe Mutations::WhatToDiscardProblems::Bookmarks::DeleteWhatToDiscardProblemBookmark, type: :request do
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
          deleteWhatToDiscardProblemBookmark(input: { problemId: $problemId }) {
            id
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblemBookmark]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "削除に失敗した場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          bookmark = instance_double(Bookmark, destroy: false, errors:, id: 1)
          allow(current_user.created_bookmarks).to receive(:find_by!).and_return(bookmark)
        end

        it "エラーが返ること" do
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemBookmark]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "削除に成功した場合" do
        let!(:bookmark) { create(:bookmark, user: current_user, bookmarkable: problem) }

        it "ブックマークが削除できること" do
          expect { subject }.to change(Bookmark, :count).by(-1)

          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemBookmark][:id].to_i).to eq bookmark.id
        end
      end
    end
  end
end
