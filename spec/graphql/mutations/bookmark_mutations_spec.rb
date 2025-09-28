# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bookmark Mutations", type: :request do
  let(:user) { create(:user) }
  let(:problem) { create(:what_to_discard_problem) }

  describe "createWhatToDiscardProblemBookmark" do
    let(:mutation) do
      <<~GRAPHQL
        mutation CreateBookmark($problemId: ID!) {
          createWhatToDiscardProblemBookmark(input: { problemId: $problemId }) {
            bookmark {
              id
              userId
              problemId
            }
            success
            errors
          }
        }
      GRAPHQL
    end

    context "ログインしている場合" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      context "お気に入り未登録の場合" do
        it "お気に入りを作成できる" do
          expect {
            post "/graphql", params: {
              query: mutation,
              variables: { problemId: problem.id.to_s },
            }
          }.to change(Bookmark, :count).by(1)

          json = JSON.parse(response.body)
          data = json["data"]["createWhatToDiscardProblemBookmark"]

          expect(data["success"]).to be true
          expect(data["bookmark"]["userId"]).to eq user.id.to_s
          expect(data["bookmark"]["problemId"]).to eq problem.id.to_s
          expect(data["errors"]).to be_empty
        end
      end

      context "既にお気に入り登録済みの場合" do
        before do
          user.created_bookmarks.create!(bookmarkable: problem)
        end

        it "エラーを返す" do
          expect {
            post "/graphql", params: {
              query: mutation,
              variables: { problemId: problem.id.to_s },
            }
          }.not_to change(Bookmark, :count)

          json = JSON.parse(response.body)
          data = json["data"]["createWhatToDiscardProblemBookmark"]

          expect(data["success"]).to be false
          expect(data["bookmark"]).to be_nil
          expect(data["errors"]).not_to be_empty
        end
      end

      context "自分の問題をお気に入りしようとする場合" do
        let(:own_problem) { create(:what_to_discard_problem, user: user) }

        it "エラーを返す" do
          expect {
            post "/graphql", params: {
              query: mutation,
              variables: { problemId: own_problem.id.to_s },
            }
          }.not_to change(Bookmark, :count)

          json = JSON.parse(response.body)
          data = json["data"]["createWhatToDiscardProblemBookmark"]

          expect(data["success"]).to be false
          expect(data["bookmark"]).to be_nil
          expect(data["errors"]).to include("自分の問題はブックマークできません")
        end
      end
    end

    context "ログインしていない場合" do
      it "エラーを返す" do
        post "/graphql", params: {
          query: mutation,
          variables: { problemId: problem.id.to_s },
        }

        json = JSON.parse(response.body)
        data = json["data"]["createWhatToDiscardProblemBookmark"]

        expect(data["success"]).to be false
        expect(data["errors"]).to include("ログインが必要です")
      end
    end
  end

  describe "deleteWhatToDiscardProblemBookmark" do
    let(:mutation) do
      <<~GRAPHQL
        mutation DeleteBookmark($problemId: ID!) {
          deleteWhatToDiscardProblemBookmark(input: { problemId: $problemId }) {
            success
            errors
          }
        }
      GRAPHQL
    end

    context "ログインしている場合" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      context "お気に入り登録済みの場合" do
        before do
          user.created_bookmarks.create!(bookmarkable: problem)
        end

        it "お気に入りを削除できる" do
          expect {
            post "/graphql", params: {
              query: mutation,
              variables: { problemId: problem.id.to_s },
            }
          }.to change(Bookmark, :count).by(-1)

          json = JSON.parse(response.body)
          data = json["data"]["deleteWhatToDiscardProblemBookmark"]

          expect(data["success"]).to be true
          expect(data["errors"]).to be_empty
        end
      end

      context "お気に入り未登録の場合" do
        it "エラーを返す" do
          post "/graphql", params: {
            query: mutation,
            variables: { problemId: problem.id.to_s },
          }

          json = JSON.parse(response.body)
          data = json["data"]["deleteWhatToDiscardProblemBookmark"]

          expect(data["success"]).to be false
          expect(data["errors"]).to include("お気に入りが見つかりません")
        end
      end
    end

    context "ログインしていない場合" do
      it "エラーを返す" do
        post "/graphql", params: {
          query: mutation,
          variables: { problemId: problem.id.to_s },
        }

        json = JSON.parse(response.body)
        data = json["data"]["deleteWhatToDiscardProblemBookmark"]

        expect(data["success"]).to be false
        expect(data["errors"]).to include("ログインが必要です")
      end
    end
  end
end
