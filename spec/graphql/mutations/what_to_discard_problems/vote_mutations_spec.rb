# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Vote Mutations", type: :request do
  include GraphqlHelper

  describe "createWhatToDiscardProblemVote" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:tile) { create(:tile) }
    let(:variables) { { problemId: problem.id.to_s, tileId: tile.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($problemId: ID!, $tileId: ID!) {
          createWhatToDiscardProblemVote(input: { problemId: $problemId, tileId: $tileId }) {
            vote {
              id
              userId
              whatToDiscardProblemId
              tileId
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblemVote]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "saveが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          vote = instance_double(WhatToDiscardProblem::Vote, save: false, errors:)
          allow(current_user.created_what_to_discard_problem_votes).to receive(:new).and_return(vote)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemVote]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "saveが成功する場合" do
        it "投票が作成できること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblemVote]).to be_present
        end
      end
    end
  end

  describe "deleteWhatToDiscardProblemVote" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem) }
    let(:tile) { create(:tile) }
    let(:vote) { create(:what_to_discard_problem_vote, user: current_user, what_to_discard_problem: problem, tile:) }
    let(:variables) { { whatToDiscardProblemId: problem.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($whatToDiscardProblemId: ID!) {
          deleteWhatToDiscardProblemVote(input: { whatToDiscardProblemId: $whatToDiscardProblemId }) {
            success
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblemVote]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "投票していない問題を削除しようとする場合" do
        let(:other_problem) { create(:what_to_discard_problem) }
        let(:variables) { { whatToDiscardProblemId: other_problem.id.to_s } }

        it "エラーが返ること" do
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemVote]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "削除が成功する場合" do
        it "投票が削除できること" do
          vote  # 投票を作成
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblemVote][:success]).to eq(true)
        end
      end
    end
  end
end
