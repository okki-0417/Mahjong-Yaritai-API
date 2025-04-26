# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblem, type: :model do
  describe "validations" do
    let(:round) { 1 }
    let(:turn) { 1 }
    let(:wind) { "東" }
    let(:dora_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 1, name: "一萬").id }
    let(:point_east) { 25000 }
    let(:point_south) { 25000 }
    let(:point_west) { 25000 }
    let(:point_north) { 25000 }
    let(:hand1_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 1, name: "一萬").id }
    let(:hand2_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 2, name: "二萬").id }
    let(:hand3_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 3, name: "三萬").id }
    let(:hand4_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 4, name: "四萬").id }
    let(:hand5_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 5, name: "五萬").id }
    let(:hand6_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 6, name: "六萬").id }
    let(:hand7_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 7, name: "七萬").id }
    let(:hand8_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 8, name: "八萬").id }
    let(:hand9_id) { create(:tile, suit: "manzu", ordinal_number_in_suit: 9, name: "九萬").id }
    let(:hand10_id) { create(:tile, suit: "pinzu", ordinal_number_in_suit: 1 , name: "一筒").id }
    let(:hand11_id) { create(:tile, suit: "pinzu", ordinal_number_in_suit: 2, name: "二筒").id }
    let(:hand12_id) { create(:tile, suit: "pinzu", ordinal_number_in_suit: 3, name: "三筒").id }
    let(:hand13_id) { create(:tile, suit: "pinzu", ordinal_number_in_suit: 4, name: "四筒").id }
    let(:tsumo_id) { create(:tile, suit: "pinzu", ordinal_number_in_suit: 5, name: "五筒").id }

    subject {
      described_class.new(
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
        tsumo_id:,
      )
    }

    describe "#confirm_no_more_than_four_duplicated_tiles" do
      context "手牌に同じ牌が5枚以上ある場合" do
        let(:hand2_id) { hand1_id }
        let(:hand3_id) { hand1_id }
        let(:hand4_id) { hand1_id }
        let(:hand5_id) { hand1_id }

        it "バリデーションが落ちること" do
          expect(subject).to be_invalid
          expect(subject.errors).to be_added(:base, :too_many_duplicated_tiles)
        end
      end
    end
  end
end
