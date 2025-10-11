# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Like Mutations", type: :request do
  include GraphqlHelper

  describe "createWhatToDiscardProblemLike" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:variables) { { problemId: problem.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($problemId: ID!) {
          createWhatToDiscardProblemLike(input: { problemId: $problemId }) {
            like {
              id
              userId
              likableId
              likableType
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblemLike]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "saveが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          like = instance_double(Like, save: false, errors:)
          allow(current_user.created_likes).to receive(:new).and_return(like)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemLike]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "saveが成功する場合" do
        it "いいねが作成できること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemLike]).to be_present
        end
      end
    end
  end

  describe "deleteWhatToDiscardProblemLike" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:like) { create(:like, user: current_user, likable: problem) }
    let(:variables) { { whatToDiscardProblemId: problem.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!) {
          deleteWhatToDiscardProblemLike(input: { whatToDiscardProblemId: $whatToDiscardProblemId }) {
            success
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblemLike]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "いいねしていない問題を削除しようとする場合" do
        let(:other_problem) { create(:what_to_discard_problem) }
        let(:variables) { { whatToDiscardProblemId: other_problem.id.to_s } }

        it "エラーが返ること" do
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemLike]).to be_nil
          expect(json[:errors].any?).to be true
          expect(json[:errors][0][:message]).to eq("リソースが見つかりません")
        end
      end

      context "削除が成功する場合" do
        it "いいねが削除できること" do
          like  # いいねを作成
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemLike][:success]).to eq(true)
        end
      end
    end
  end
end
