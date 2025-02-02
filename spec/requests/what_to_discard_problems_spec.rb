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
        dora:,
        point_east:,
        point_south:,
        point_west:,
        point_north:,
        hand1:,
        hand2:,
        hand3:,
        hand4:,
        hand5:,
        hand6:,
        hand7:,
        hand8:,
        hand9:,
        hand10:,
        hand11:,
        hand12:,
        hand13:,
        tsumo:
      }
    }}

    let(:round) { "東一" }
    let(:turn) { "1" }
    let(:wind) { "東" }
    let(:dora) { "1" }
    let(:point_east) { "250" }
    let(:point_south) { "250" }
    let(:point_west) { "250" }
    let(:point_north) { "250" }
    let(:hand1) { "1" }
    let(:hand2) { "2" }
    let(:hand3) { "3" }
    let(:hand4) { "4" }
    let(:hand5) { "5" }
    let(:hand6) { "6" }
    let(:hand7) { "7" }
    let(:hand8) { "8" }
    let(:hand9) { "9" }
    let(:hand10) { "10" }
    let(:hand11) { "11" }
    let(:hand12) { "12" }
    let(:hand13) { "13" }
    let(:tsumo) { "14" }

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
end
