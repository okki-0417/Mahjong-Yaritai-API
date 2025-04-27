# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WhatToDiscardProblems", type: :request do
  let(:current_user) { FactoryBot.create(:user) }

  describe "#create" do
    subject { post what_to_discard_problems_url, params: {
      what_to_discard_problem: {
        round:,
        turn:,
        wind:,
        dora_id:,
        point_east:,
        point_south:,
        point_west:,
        point_north:,
        hand1_id:,
        hand2_id:,
        hand3_id:,
        hand4_id:,
        hand5_id:,
        hand6_id:,
        hand7_id:,
        hand8_id:,
        hand9_id:,
        hand10_id:,
        hand11_id:,
        hand12_id:,
        hand13_id:,
        tsumo_id:
      }
    }}

    let(:round) { "東一" }
    let(:turn) { 1 }
    let(:wind) { "東" }
    let(:dora_id) { 1 }
    let(:point_east) { 25000 }
    let(:point_south) { 25000 }
    let(:point_west) { 25000 }
    let(:point_north) { 25000 }
    let(:hand1_id) { 1 }
    let(:hand2_id) { 2 }
    let(:hand3_id) { 3 }
    let(:hand4_id) { 4 }
    let(:hand5_id) { 5 }
    let(:hand6_id) { 6 }
    let(:hand7_id) { 7 }
    let(:hand8_id) { 8 }
    let(:hand9_id) { 9 }
    let(:hand10_id) { 10 }
    let(:hand11_id) { 11 }
    let(:hand12_id) { 12 }
    let(:hand13_id) { 13 }
    let(:tsumo_id) { 14 }

    context "未ログインの場合" do
      it_behaves_like :response, 401
    end

    context "ログイン済みの場合" do
      include_context "logged_in"

      context "不正な値の場合" do
        context "手牌に同じ牌が5枚以上存在する場合" do
          let(:hand2) { "1" }
          let(:hand3) { "1" }
          let(:hand4) { "1" }
          let(:hand5) { "1" }

          it_behaves_like :response, 422
        end

        context "空の値が含まれている場合" do
          let(:hand1) { "" }

          it_behaves_like :response, 422
        end
      end

      context "全ての値が正常に満たされている場合" do
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
