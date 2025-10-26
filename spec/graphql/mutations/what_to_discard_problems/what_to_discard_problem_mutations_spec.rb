# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblem Mutations", type: :request do
  include GraphqlHelper

  describe "createWhatToDiscardProblem" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:tiles) { create_list(:tile, 14) }
    let(:dora) { create(:tile) }
    let(:variables) do
      {
        description: "Test Description",
        doraId: dora.id.to_s,
        hand1Id: tiles[0].id.to_s,
        hand2Id: tiles[1].id.to_s,
        hand3Id: tiles[2].id.to_s,
        hand4Id: tiles[3].id.to_s,
        hand5Id: tiles[4].id.to_s,
        hand6Id: tiles[5].id.to_s,
        hand7Id: tiles[6].id.to_s,
        hand8Id: tiles[7].id.to_s,
        hand9Id: tiles[8].id.to_s,
        hand10Id: tiles[9].id.to_s,
        hand11Id: tiles[10].id.to_s,
        hand12Id: tiles[11].id.to_s,
        hand13Id: tiles[12].id.to_s,
        tsumoId: tiles[13].id.to_s,
      }
    end
    let(:mutation) do
      <<~GQL
        mutation(
          $description: String
          $doraId: ID!
          $hand1Id: ID!
          $hand2Id: ID!
          $hand3Id: ID!
          $hand4Id: ID!
          $hand5Id: ID!
          $hand6Id: ID!
          $hand7Id: ID!
          $hand8Id: ID!
          $hand9Id: ID!
          $hand10Id: ID!
          $hand11Id: ID!
          $hand12Id: ID!
          $hand13Id: ID!
          $tsumoId: ID!
        ) {
          createWhatToDiscardProblem(input: {
            description: $description
            doraId: $doraId
            hand1Id: $hand1Id
            hand2Id: $hand2Id
            hand3Id: $hand3Id
            hand4Id: $hand4Id
            hand5Id: $hand5Id
            hand6Id: $hand6Id
            hand7Id: $hand7Id
            hand8Id: $hand8Id
            hand9Id: $hand9Id
            hand10Id: $hand10Id
            hand11Id: $hand11Id
            hand12Id: $hand12Id
            hand13Id: $hand13Id
            tsumoId: $tsumoId
          }) {
            whatToDiscardProblem {
              id
              description
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:createWhatToDiscardProblem]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "saveが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          problem = instance_double(WhatToDiscardProblem, save: false, errors:)
          allow(current_user.created_what_to_discard_problems).to receive(:new).and_return(problem)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblem]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "saveが成功する場合" do
        it "問題が作成できること" do
          json = subject

          expect(json[:data][:createWhatToDiscardProblem]).to be_present
        end
      end
    end
  end

  describe "deleteWhatToDiscardProblem" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem, user: current_user) }
    let(:variables) { { id: problem.id.to_s } }
    let(:mutation) do
      <<~GQL
        mutation($id: ID!) {
          deleteWhatToDiscardProblem(input: { id: $id }) {
            id
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }
      let(:problem) { create(:what_to_discard_problem) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:deleteWhatToDiscardProblem]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "自分の問題ではない場合" do
        let(:other_user) { create(:user) }
        let(:problem) { create(:what_to_discard_problem, user: other_user) }

        it "エラーが返ること" do
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblem]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "削除が成功する場合" do
        it "問題が削除できること" do
          problem  # 問題を作成
          json = subject

          expect(json[:data][:deleteWhatToDiscardProblem]).to be_present
        end
      end
    end
  end

  describe "updateWhatToDiscardProblem" do
    subject do
      execute_mutation(mutation, variables, context: { current_user: })
      JSON.parse(response.body, symbolize_names: true)
    end

    let(:current_user) { create(:user) }
    let(:problem) { create(:what_to_discard_problem, user: current_user, description: "Old description") }
    let(:variables) { { id: problem.id.to_s, description: "Updated description" } }
    let(:mutation) do
      <<~GQL
        mutation($id: ID!, $description: String) {
          updateWhatToDiscardProblem(input: { id: $id, description: $description }) {
            whatToDiscardProblem {
              id
              description
            }
          }
        }
      GQL
    end

    context "ログインしていない場合" do
      let(:current_user) { nil }
      let(:problem) { create(:what_to_discard_problem) }

      it "エラーが返ること" do
        json = subject

        expect(json[:data][:updateWhatToDiscardProblem]).to be_nil
        expect(json[:errors].any?).to be true
      end
    end

    context "ログインしている場合" do
      context "updateが失敗する場合" do
        before do
          errors = double(full_messages: [ "バリデーションエラー" ])
          allow(problem).to receive(:update).and_return(false)
          allow(problem).to receive(:errors).and_return(errors)
          allow(current_user.created_what_to_discard_problems).to receive(:find).and_return(problem)
        end

        it "バリデーションエラーが返ること" do
          json = subject

          expect(json[:data][:updateWhatToDiscardProblem]).to be_nil
          expect(json[:errors].any?).to be true
        end
      end

      context "updateが成功する場合" do
        it "問題を更新できること" do
          json = subject

          expect(json[:data][:updateWhatToDiscardProblem]).to be_present
        end
      end
    end
  end
end
