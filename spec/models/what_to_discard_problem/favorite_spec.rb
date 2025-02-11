# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblem::Like, type: :model do
  describe "#validates" do
    let(:user) { FactoryBot.create(:user) }
    let(:user_id) { user.id }
    let(:what_to_discard_problem) { FactoryBot.create(:what_to_discard_problem) }
    let(:what_to_discard_problem_id) { what_to_discard_problem.id }

    subject { described_class.new(
      user_id:,
      what_to_discard_problem_id:
    ) }

    context "同じユーザーが重複して作成した場合" do
      let!(:what_to_discard_problem_likes) { FactoryBot.create(:what_to_discard_problem_likes, user:, what_to_discard_problem:) }
      before { user_id }

      it_behaves_like :invalid

      it "エラーが追加されていること" do
        subject.valid?
        expect(subject.errors).to be_added(:user_id, :taken, value: user_id)
      end
    end
  end
end
