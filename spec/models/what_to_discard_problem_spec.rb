# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblem, type: :model do
  describe "validations" do
    let(:round) { 1 }
    let(:turn) { 1 }
    let(:wind) { "東" }
    let(:dora) { 1 }
    let(:point_east) { 250 }
    let(:point_south) { 250 }
    let(:point_west) { 250 }
    let(:point_north) { 250 }
    let(:hand1) { 1 }
    let(:hand2) { 2 }
    let(:hand3) { 3 }
    let(:hand4) { 4 }
    let(:hand5) { 5 }
    let(:hand6) { 6 }
    let(:hand7) { 7 }
    let(:hand8) { 8 }
    let(:hand9) { 9 }
    let(:hand10) { 10 }
    let(:hand11) { 11 }
    let(:hand12) { 12 }
    let(:hand13) { 13 }
    let(:tsumo) { 1 }

    subject {
      described_class.new(
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
        tsumo:,
      )
    }

    context "局名が空の場合" do
      let(:round) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:round, :blank)
      end
    end

    context "巡目が空の場合" do
      let(:turn) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:turn, :blank)
      end
    end

    context "風が空の場合" do
      let(:wind) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:wind, :blank)
      end
    end

    context "ドラが空の場合" do
      let(:dora) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:dora, :blank)
      end
    end

    context "得点のどれかが空の場合" do
      let(:point_east) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:point_east, :blank)
      end
    end

    context "手牌のどれかが空の場合" do
      let(:hand1) { nil }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:hand1, :blank)
      end
    end

    context "手牌に同じ牌が5枚以上ある場合" do
      let(:hand2) { 1 }
      let(:hand3) { 1 }
      let(:hand4) { 1 }
      let(:hand5) { 1 }

      it "バリデーションが落ちること" do
        expect(subject).to be_invalid
        expect(subject.errors).to be_added(:base, :too_many_duplicates)
      end
    end
  end
end
