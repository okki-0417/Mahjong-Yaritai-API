# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblems", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#create" do
    subject do
      post what_to_discard_problems_url, params: {
        what_to_discard_problem: {
          round: "東一",
          turn: 1,
          wind: "東",
          dora_id: create(:tile).id,
          point_east: 25000,
          point_south: 25000,
          point_west: 25000,
          point_north: 25000,
          hand1_id: create(:tile).id,
          hand2_id: create(:tile).id,
          hand3_id: create(:tile).id,
          hand4_id: create(:tile).id,
          hand5_id: create(:tile).id,
          hand6_id: create(:tile).id,
          hand7_id: create(:tile).id,
          hand8_id: create(:tile).id,
          hand9_id: create(:tile).id,
          hand10_id: create(:tile).id,
          hand11_id: create(:tile).id,
          hand12_id: create(:tile).id,
          hand13_id: create(:tile).id,
          tsumo_id: create(:tile).id,
        }
      }
    end

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "バリデーションに通らない場合" do
        before { allow_any_instance_of(WhatToDiscardProblem).to receive(:save).and_return(false) }

        it_behaves_like :response, 422
      end

      context "バリデーションに通る場合" do
        it_behaves_like :response, 201
      end
    end
  end

  describe "#destroy" do
    subject { delete what_to_discard_problem_url(what_to_discard_problem) }

    let(:what_to_discard_problem) { create(:what_to_discard_problem, user: current_user) }
    let(:current_user) { create(:user) }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "削除に失敗した場合" do
        before { allow_any_instance_of(WhatToDiscardProblem).to receive(:destroy).and_return(false) }

        it_behaves_like :response, 422
      end

      context "削除に成功した場合" do
        it_behaves_like :response, 204
      end
    end
  end
end
