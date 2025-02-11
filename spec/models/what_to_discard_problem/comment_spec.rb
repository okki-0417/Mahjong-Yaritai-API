# frozen_string_literal: true

require "rails_helper"

RSpec.describe WhatToDiscardProblem::Comment, type: :model do
  describe "validations" do
    let(:user_id) { FactoryBot.create(:user).id }
    let(:what_to_discard_problem_id) { FactoryBot.create(:what_to_discard_problem).id }
    let(:parent_comment_id) { nil }

    let(:content) { nil }

    subject {
      described_class.new(
        user_id:,
        what_to_discard_problem_id:,
        parent_comment_id:,
        content:,
      )
    }

    context "本文が空の場合" do
      it_behaves_like :invalid
      it_behaves_like :error_added, :content, :blank
    end

    context "本文が存在する場合" do
      context "500文字を超える場合" do
        let(:content) { "a" * 501 }

        it_behaves_like :invalid
        it_behaves_like :error_added, :content, :too_long, count: 500
      end

      context "500文字以内の場合" do
        let(:content) { "a" * 500 }

        context "返信先がないコメントの場合" do
          let(:parent_id) { nil }

          it_behaves_like :valid
        end

        context "返信先があるコメントの場合" do
          context "存在しない親コメントを参照していた場合" do
            let(:parent_comment_id) { 9999 }

            it_behaves_like :invalid
            it_behaves_like :error_added, :parent_comment_id, :missing_parent_comment
          end

          context "存在する親コメントを参照している場合" do
            let(:parent_comment_id) { FactoryBot.create(:what_to_discard_problem_comment).id }

            it_behaves_like :valid
          end
        end
      end
    end
  end
end
