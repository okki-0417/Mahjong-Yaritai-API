# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bookmark Mutations", type: :request do
  include GraphqlHelper

  describe "createWhatToDiscardProblemBookmark" do
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

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblemBookmark]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "saveが失敗する場合" do
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

      context "saveが成功する場合" do
        it "ブックマークが作成できること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemBookmark]).to be_present
        end
      end
    end
  end

  describe "deleteWhatToDiscardProblemBookmark" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:bookmark) { create(:bookmark, user: current_user, bookmarkable: problem) }
    let(:variables) { { problemId: problem.id.to_s } }
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
      context "ブックマークしていない問題を削除しようとする場合" do
        let(:other_problem) { create(:what_to_discard_problem) }
        let(:variables) { { problemId: other_problem.id.to_s } }

        it "エラーが返ること" do
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemBookmark]).to be_nil
          expect(json[:errors].any?).to be true
          expect(json[:errors][0][:message]).to eq("リソースが見つかりません")
        end
      end

      context "削除が成功する場合" do
        it "ブックマークが削除できること" do
          bookmark  # ブックマークを作成
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemBookmark]).to be_present
        end
      end
    end
  end
end
